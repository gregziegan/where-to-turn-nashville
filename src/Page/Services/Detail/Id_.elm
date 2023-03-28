module Page.Services.Detail.Id_ exposing (Data, Model, Msg, RouteParams, page)

import Button
import DataSource exposing (DataSource)
import DataSource.Http
import DataSource.Port
import Element exposing (Element, alignTop, column, el, fill, link, maximum, newTabLink, padding, paddingXY, paragraph, row, spacing, text, textColumn, width)
import Element.Font as Font
import FontAwesome
import Head
import Head.Seo as Seo
import Json.Encode
import Link exposing (call, directions)
import List.Extra
import OptimizedDecoder as Decode
import Organization exposing (Organization)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Phone
import Service exposing (Service)
import Shared
import Spreadsheet
import Util
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
        (Spreadsheet.fromSecrets Service.sheetId Service.sheetRange)
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
        index : Int
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
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Where to turn in Nashville"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "Where to turn in Nashville"
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


viewDescription : { a | description : String } -> Element msg
viewDescription service =
    let
        services : List String
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


viewUnorderedList : List String -> Element msg
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


viewHeader : List (Element msg) -> Element msg
viewHeader children =
    row [ width fill ]
        [ textColumn [ width fill, spacing 5 ]
            children
        ]


viewSection : List (Element msg) -> Element msg
viewSection children =
    row [ width fill ]
        [ textColumn [ width fill, spacing 10, paddingXY 10 0 ]
            children
        ]


viewService : Organization -> Service -> Element Msg
viewService organization service =
    column [ width (fill |> maximum 800), padding 10, spacing 10 ]
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
                            [ paragraph [] [ text hours ]
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
            ++ [ row [ width fill ]
                    [ column [ width fill, spacing 10 ]
                        [ Util.renderWhenPresent directions organization.address
                        , Util.renderWhenPresent call organization.phone
                        , Maybe.withDefault Element.none <| Maybe.map Link.website organization.website
                        ]
                    ]
               ]
        )


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
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
