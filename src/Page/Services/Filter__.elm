module Page.Services.Filter__ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Http
import Dict exposing (Dict)
import Element exposing (DeviceClass(..), Element, centerX, column, fill, link, maximum, padding, paragraph, row, spacing, text, textColumn, width)
import Element.Font as Font
import ElmTextSearch exposing (Index)
import Head
import Head.Seo as Seo
import OptimizedDecoder as Decode
import Organization exposing (Organization)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Pages.Url
import Search
import Service exposing (Category, Service)
import Shared
import Spreadsheet
import String.Extra
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { filter : Maybe String
    }


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
    DataSource.succeed
        (RouteParams Nothing
            :: List.map
                (RouteParams << Just << Service.categoryToString)
                Service.categories
        )


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\services ->
            Data services
                (if routeParams.filter == Nothing then
                    Just
                        (Tuple.first
                            (Search.allServicesAdded (Dict.values services))
                        )

                 else
                    Nothing
                )
        )
        (DataSource.Http.get
            (Secrets.succeed
                (Spreadsheet.url Service.sheetId "A2:P")
                |> Secrets.with "GOOGLE_API_KEY"
            )
            (Decode.field "values"
                (Decode.list Service.decoder |> Decode.map toDict)
            )
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
    { services : Dict Int Service
    , searchIndex : Maybe (ElmTextSearch.Index Service)
    }


toDict entities =
    entities
        |> List.map (\e -> ( e.id, e ))
        |> Dict.fromList


filterServiceByCategory : Maybe Category -> Service -> Maybe Service
filterServiceByCategory category service =
    if category == Nothing || category == Just service.category then
        Just service

    else
        Nothing


viewSearchFilteredList : (Service -> Element Msg) -> Dict Int Service -> Result String ( Index Service, List ( String, Float ) ) -> Element Msg
viewSearchFilteredList toItem services searchResult =
    case searchResult of
        Ok rankings ->
            column [ spacing 20, width fill ]
                (List.filterMap
                    (\( id, _ ) ->
                        services
                            |> Dict.get (Maybe.withDefault 0 <| String.toInt id)
                            |> Maybe.map toItem
                    )
                    (Tuple.second rankings)
                )

        Err str ->
            text <| "No results matching search query. " ++ str


viewList : (Service -> Element Msg) -> StaticPayload Data RouteParams -> Element Msg
viewList toItem static =
    let
        maybeCategory =
            Maybe.andThen Service.categoryFromString static.routeParams.filter
    in
    column [ spacing 20, width fill ]
        (List.filterMap
            (Maybe.map toItem << filterServiceByCategory maybeCategory)
            (Dict.values static.data.services)
        )


viewMobile filterText sharedModel static =
    [ column
        [ width (fill |> maximum 1200)
        , padding 10
        , spacing 10
        ]
        [ paragraph [ Font.semiBold ]
            [ text filterText
            ]
        , case ( sharedModel.searchQuery, static.data.searchIndex ) of
            ( Just query, Just searchIndex ) ->
                viewSearchFilteredList (Service.listItem 1.7)
                    static.data.services
                    (ElmTextSearch.search query searchIndex)

            ( _, _ ) ->
                viewList (Service.listItem 1.7) static
        ]
    ]


viewDesktop filterText sharedModel static =
    [ column
        [ width fill
        , padding 10
        , spacing 10
        ]
        [ paragraph [ Font.semiBold ]
            [ text filterText
            ]
        , case ( sharedModel.searchQuery, static.data.searchIndex ) of
            ( Just query, Just searchIndex ) ->
                viewSearchFilteredList
                    (Service.largeListItem 1.7)
                    static.data.services
                    (ElmTextSearch.search query searchIndex)

            ( _, _ ) ->
                viewList (Service.largeListItem 1.7) static
        ]
    ]


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    let
        filterText =
            Maybe.withDefault "All services" <|
                Maybe.map String.Extra.toSentenceCase static.routeParams.filter

        device =
            Element.classifyDevice sharedModel.window
    in
    { title = "Where to turn in Nashville | " ++ filterText
    , body =
        (case device.class of
            Phone ->
                viewMobile

            Tablet ->
                viewMobile

            Desktop ->
                viewDesktop

            BigDesktop ->
                viewDesktop
        )
            filterText
            sharedModel
            static
    }
