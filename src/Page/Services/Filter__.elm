module Page.Services.Filter__ exposing (Data, Model, Msg, RouteParams, page)

import DataSource exposing (DataSource)
import DataSource.Http
import Dict exposing (Dict)
import Element exposing (Device, DeviceClass(..), Element, column, fill, maximum, padding, paragraph, spacing, text, width)
import Element.Font as Font
import ElmTextSearch exposing (Index)
import Head
import Head.Seo as Seo
import OptimizedDecoder as Decode
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
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
            (Spreadsheet.fromSecrets Service.sheetId Service.sheetRange)
            (Decode.field "values"
                (Decode.list Service.decoder |> Decode.map toDict)
            )
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
    { services : Dict Int Service
    , searchIndex : Maybe (ElmTextSearch.Index Service)
    }


toDict : List { a | id : comparable } -> Dict comparable { a | id : comparable }
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
        maybeCategory : Maybe Category
        maybeCategory =
            Maybe.andThen Service.categoryFromString static.routeParams.filter
    in
    column [ spacing 20, width fill ]
        (List.filterMap
            (Maybe.map toItem << filterServiceByCategory maybeCategory)
            (Dict.values static.data.services)
        )


viewMobile : String -> Shared.Model -> StaticPayload Data RouteParams -> List (Element Msg)
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

            _ ->
                viewList (Service.listItem 1.7) static
        ]
    ]


viewDesktop : String -> Shared.Model -> StaticPayload Data RouteParams -> List (Element Msg)
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

            _ ->
                viewList (Service.largeListItem 1.7) static
        ]
    ]


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ sharedModel static =
    let
        filterText : String
        filterText =
            Maybe.withDefault "All services" <|
                Maybe.map String.Extra.toSentenceCase static.routeParams.filter

        device : Device
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
