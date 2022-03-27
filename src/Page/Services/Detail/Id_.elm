module Page.Services.Detail.Id_ exposing (Data, Model, Msg, page)

import Breadcrumbs
import Button
import DataSource exposing (DataSource)
import DataSource.Http
import DataSource.Port
import Dict
import Element exposing (Element, alignLeft, centerX, column, el, fill, link, maximum, newTabLink, padding, paragraph, row, spacing, text, textColumn, width, wrappedRow)
import Element.Font as Font
import Element.Input as Input
import FontAwesome exposing (fontAwesome)
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
    DataSource.Port.get "services"
        (Json.Encode.string "meh")
        (Decode.field "values"
            (Decode.list
                (Decode.index 0 Decode.int
                    |> Decode.map (String.fromInt >> RouteParams)
                )
            )
        )


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.Port.get "service"
        (Json.Encode.string routeParams.id)
        (Decode.nullable Service.decoder)
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
    textColumn [ width fill ]
        [ paragraph [ width fill ] [ text service.description ]
        ]


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
                |> Button.render
        }


viewSection children =
    row [ width fill ]
        [ textColumn [ width fill, spacing 10, padding 10 ]
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
    column [ width fill, spacing 10 ]
        [ viewSection
            [ link [] { url = "/organizations/detail/" ++ String.fromInt organization.id, label = paragraph [ Font.bold ] [ text organization.name ] }
            , el [ alignLeft ] <| Element.html <| FontAwesome.iconWithOptions FontAwesome.infoCircle FontAwesome.Solid [ FontAwesome.Size FontAwesome.Large ] []
            , paragraph [ Font.italic ] [ text "Organization" ]
            ]
        , viewSection
            [ paragraph [] [ text <| Maybe.withDefault "" <| service.address ] ]
        , viewSection
            [ viewDescription service
            ]
        , viewSection
            [ paragraph [ Font.bold ] [ text "Requirements" ]
            , paragraph [] [ text <| Maybe.withDefault "" <| service.requirements ]
            ]
        , viewSection
            [ paragraph [ Font.bold ] [ text "Hours" ]
            , paragraph [] [ text <| Maybe.withDefault "" <| Maybe.map Schedule.toString service.hours ]
            ]
        , viewSection
            [ paragraph [ Font.bold ] [ text "How to apply" ]
            , paragraph [] [ text <| Maybe.withDefault "" <| service.applicationProcess ]
            ]
        , row [ width fill ]
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


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Where to turn in Nashville | Service"
    , body =
        [ column
            [ centerX
            , width (fill |> maximum 1200)
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
