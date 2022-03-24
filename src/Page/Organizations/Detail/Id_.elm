module Page.Organizations.Detail.Id_ exposing (Data, Model, Msg, page)

import Breadcrumbs
import DataSource exposing (DataSource)
import DataSource.Http
import Dict
import Element exposing (Element, alignLeft, centerX, column, el, fill, link, maximum, padding, paragraph, row, spacing, text, textColumn, width, wrappedRow)
import Element.Font as Font
import Element.Input as Input
import FontAwesome
import Head
import Head.Seo as Seo
import OptimizedDecoder as Decode
import Organization exposing (Organization)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Pages.Url
import Service
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
            (Spreadsheet.url Organization.sheetId "A2:B")
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


currentOrganization { organizations } params =
    let
        maybeOrganization =
            params.id
                |> String.toInt
                |> Maybe.andThen (\id -> Dict.get id organizations)
    in
    case maybeOrganization of
        Just organization ->
            viewOrganization organization

        Nothing ->
            text "not found"


viewSection children =
    row [ width fill ]
        [ textColumn [ width fill, spacing 10, padding 10 ]
            children
        ]


viewOrganization : Organization -> Element msg
viewOrganization organization =
    column [ width fill, spacing 10 ]
        [ viewSection
            [ paragraph [ Font.bold ] [ text organization.name ]
            , el [ alignLeft ] <| Element.html <| FontAwesome.iconWithOptions FontAwesome.infoCircle FontAwesome.Solid [ FontAwesome.Size FontAwesome.Large ] []
            , paragraph [ Font.italic ] [ text "Organization" ]
            ]
        , case organization.website of
            Just "" ->
                Element.none

            Just websiteLink ->
                viewSection
                    [ paragraph [ Font.bold ] [ text "Website" ]
                    , link [] { url = websiteLink, label = text websiteLink }
                    ]

            Nothing ->
                Element.none
        ]


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Where to turn in Nashville | Organization"
    , body =
        [ column
            [ centerX
            , width (fill |> maximum 1200)
            , padding 10
            , spacing 10
            ]
            [ currentOrganization static.sharedData static.routeParams
            ]
        ]
    }
