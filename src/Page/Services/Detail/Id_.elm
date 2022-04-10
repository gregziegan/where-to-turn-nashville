module Page.Services.Detail.Id_ exposing (Data, Model, Msg, page)

import Breadcrumbs
import Button
import DataSource exposing (DataSource)
import DataSource.Http
import DataSource.Port
import Dict
import Element exposing (Element, alignLeft, alignRight, alignTop, centerX, column, el, fill, link, maximum, newTabLink, padding, paddingXY, paragraph, row, spacing, text, textColumn, width, wrappedRow)
import Element.Font as Font
import Element.Input as Input
import FontAwesome exposing (Transform)
import Head
import Head.Seo as Seo
import Json.Encode
import List.Extra
import Mask
import OptimizedDecoder as Decode
import Organization exposing (Organization)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Pages.Url
import Path
import QueryParams
import Schedule
import Service exposing (Service)
import Shared
import Spreadsheet
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { id : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    DataSource.Http.get
        (Secrets.succeed
            (Spreadsheet.url Service.sheetId "A2:B")
            |> Secrets.with "GOOGLE_API_KEY"
        )
        (Decode.field "values"
            (Decode.list
                (Decode.index 0 Decode.int
                    |> Decode.map (String.fromInt >> RouteParams)
                )
            )
        )


data : RouteParams -> DataSource Data
data routeParams =
    let
        index =
            case String.toInt routeParams.id of
                Just id ->
                    id + 1

                Nothing ->
                    0
    in
    DataSource.Port.get "services"
        (Json.Encode.string "meh")
        (Decode.field "values"
            (Decode.list
                Service.decoder
                |> Decode.map
                    (\l ->
                        List.Extra.find (\s -> s.id == index - 1) l
                    )
            )
        )
        |> DataSource.andThen
            (\maybeService ->
                case maybeService of
                    Just service ->
                        DataSource.map2 Tuple.pair
                            (DataSource.succeed maybeService)
                            (DataSource.Port.get "organizations"
                                (Json.Encode.string "meh")
                                (Decode.field "values"
                                    (Decode.list
                                        Organization.decoder
                                        |> Decode.map
                                            (\l ->
                                                List.Extra.find (\o -> o.name == service.organizationName) l
                                            )
                                    )
                                )
                            )

                    Nothing ->
                        DataSource.map2 Tuple.pair
                            (DataSource.succeed maybeService)
                            (DataSource.succeed Nothing)
            )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    ( Maybe Service, Maybe Organization )


viewDescription service =
    let
        services =
            String.split ";" service.description
                |> List.map String.trim
    in
    textColumn [ width fill ]
        [ if List.length services < 2 then
            paragraph [ width fill ] [ text service.description ]

          else
            viewUnorderedList services
        ]


viewUnorderedList l =
    column [ width fill ]
        (List.map
            (\item ->
                row [ width fill, spacing 5 ]
                    [ column [ alignTop ] [ text "•" ]
                    , column [ width fill ] [ paragraph [] [ text item ] ]
                    ]
            )
            l
        )


directionsLink =
    link []
        { url = "/"
        , label =
            Button.transparent
                { onPress = Nothing
                , text = "Directions"
                }
                |> Button.fullWidth
                |> Button.withIcon FontAwesome.mapMarker
                |> Button.render
        }


saveLink =
    link []
        { url = "/"
        , label =
            Button.transparent
                { onPress = Nothing
                , text = "Add to My Saved"
                }
                |> Button.fullWidth
                |> Button.withIcon FontAwesome.star
                |> Button.render
        }


smsButton =
    Button.transparent
        { onPress = Nothing
        , text = "Text me this info"
        }
        |> Button.fullWidth
        |> Button.withIcon FontAwesome.commentAlt
        |> Button.render


callLink phone =
    link []
        { url = "tel:+" ++ phone
        , label =
            Button.transparent
                { onPress = Nothing
                , text = "Call " ++ Mask.string { mask = "(###) ###-####", replace = '#' } phone
                }
                |> Button.fullWidth
                |> Button.withIcon FontAwesome.phone
                |> Button.withIconOptions [ FontAwesome.Transform [ FontAwesome.FlipHorizontal ] ]
                |> Button.render
        }


viewHeader children =
    row [ width fill ]
        [ textColumn [ width fill, spacing 5 ]
            children
        ]


viewSection children =
    row [ width fill ]
        [ textColumn [ width fill, spacing 10, paddingXY 10 0 ]
            children
        ]


websiteLink website =
    newTabLink []
        { url = website
        , label =
            row [ spacing 10, padding 10 ]
                [ text website
                , el [] <| Element.html <| FontAwesome.icon FontAwesome.externalLinkAlt
                ]
        }


viewService : Organization -> Service -> Element Msg
viewService organization service =
    column [ width fill, padding 10, spacing 10 ]
        ([ viewHeader
            [ paragraph [ Font.bold ] [ text organization.name ]
            , link [] { url = "/organizations/detail/" ++ String.fromInt organization.id, label = paragraph [ Font.italic ] [ text "Organization" ] }
            ]
         , viewSection
            [ paragraph [] [ text <| Maybe.withDefault "" <| service.address ] ]
         , viewSection
            [ viewDescription service
            ]
         ]
            ++ (case service.requirements of
                    Just "" ->
                        []

                    Just requirements ->
                        [ viewHeader
                            [ paragraph [ Font.bold ] [ text "Requirements" ]
                            ]
                        , viewSection
                            [ paragraph [] [ text requirements ] ]
                        ]

                    Nothing ->
                        []
               )
            ++ (case service.hours of
                    Just hours ->
                        [ viewHeader
                            [ paragraph [ Font.bold ] [ text "Hours" ]
                            ]
                        , viewSection
                            [ paragraph [] [ text <| Schedule.toString hours ]
                            ]
                        ]

                    Nothing ->
                        []
               )
            ++ (case service.applicationProcess of
                    Just "" ->
                        []

                    Just applicationProcess ->
                        [ viewHeader
                            [ paragraph [ Font.bold ] [ text "How to apply" ]
                            ]
                        , viewSection
                            [ paragraph [] [ text applicationProcess ]
                            ]
                        ]

                    Nothing ->
                        []
               )
            ++ (case organization.phone of
                    Just "" ->
                        []

                    Just phone ->
                        [ viewHeader
                            [ paragraph [ Font.bold ] [ text "Contact" ]
                            ]
                        , viewSection
                            [ paragraph
                                []
                                [ text ("Phone: " ++ phone) ]
                            ]
                        ]

                    Nothing ->
                        []
               )
            ++ [ row [ width fill ]
                    [ column [ width fill, spacing 10 ]
                        [ directionsLink
                        , case organization.phone of
                            Just phone ->
                                callLink phone

                            Nothing ->
                                Element.none
                        , Maybe.withDefault Element.none <| Maybe.map websiteLink organization.website
                        , smsButton
                        , saveLink
                        ]
                    ]
               ]
        )


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Where to turn in Nashville | Service"
    , body =
        [ column
            [ width fill
            , padding 10
            , spacing 10
            ]
            [ case static.data of
                ( Just service, Just organization ) ->
                    viewService organization service

                _ ->
                    text "Service not found"
            ]
        ]
    }
