module Page.Services.Filter__ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (centerX, column, fill, link, maximum, padding, paragraph, row, spacing, text, textColumn, width)
import Element.Font as Font
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Service exposing (Category, Service)
import Shared
import String.Extra
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { filter : Maybe String }


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
    DataSource.succeed (RouteParams Nothing :: List.map (RouteParams << Just << Service.categoryToString) Service.categories)


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.succeed ()


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
    ()


filterService : Maybe Category -> Service -> Maybe Service
filterService category service =
    if category == Nothing || category == Just service.category then
        Just service

    else
        Nothing


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    let
        filterText =
            Maybe.withDefault "All services" <| Maybe.map String.Extra.toSentenceCase static.routeParams.filter
    in
    { title = "Where to turn in Nashville | " ++ filterText
    , body =
        let
            selectedCategory =
                Maybe.andThen Service.categoryFromString static.routeParams.filter
        in
        [ column
            [ centerX
            , width (fill |> maximum 1200)
            , padding 10
            , spacing 10
            ]
            (paragraph [ Font.semiBold ]
                [ text filterText
                ]
                :: List.filterMap
                    (Maybe.map (Service.listItem 1.7) << filterService selectedCategory)
                    static.sharedData
            )
        ]
    }
