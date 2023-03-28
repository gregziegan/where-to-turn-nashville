module Page.Organizations.Detail.Id_ exposing (Data, Model, Msg, RouteParams, page)

import DataSource exposing (DataSource)
import DataSource.Http
import DataSource.Port
import Element exposing (Element, alignLeft, centerX, column, el, fill, link, maximum, padding, paragraph, row, spacing, text, textColumn, width)
import Element.Font as Font
import FontAwesome
import Head
import Head.Seo as Seo
import Json.Encode
import Link
import List.Extra
import OptimizedDecoder as Decode
import Organization exposing (Organization)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
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
        (Spreadsheet.fromSecrets Organization.sheetId Organization.sheetRange)
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
    DataSource.Port.get "organizations"
        (Json.Encode.string "meh")
        (Decode.field "values"
            (Decode.list
                Organization.decoder
                |> Decode.map
                    (\l ->
                        List.Extra.find (\s -> s.id == index - 1) l
                    )
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
    Maybe Organization


viewSection : List (Element msg) -> Element msg
viewSection children =
    row [ width fill ]
        [ textColumn [ width fill, spacing 10, padding 10 ]
            children
        ]


viewOrganization : Organization -> Element msg
viewOrganization organization =
    column [ width (fill |> maximum 800), spacing 10 ]
        [ viewSection
            [ paragraph [ Font.bold ] [ text organization.name ]
            , el [ alignLeft ] <| Element.html <| FontAwesome.iconWithOptions FontAwesome.infoCircle FontAwesome.Solid [ FontAwesome.Size FontAwesome.Large ] []
            , paragraph [ Font.italic ] [ text "Organization" ]
            ]
        , Util.renderWhenPresent
            (\notes ->
                viewSection
                    [ paragraph [ Font.bold ] [ text "Description" ]
                    , paragraph [] [ text notes ]
                    ]
            )
            organization.notes
        , Util.renderWhenPresent Link.directions organization.address
        , Util.renderWhenPresent Link.call organization.phone
        , Util.renderWhenPresent Link.website organization.website
        ]


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = "Where to turn in Nashville | Organization"
    , body =
        [ column
            [ centerX
            , width (fill |> maximum 1200)
            , padding 10
            , spacing 10
            ]
            [ case static.data of
                Just organization ->
                    viewOrganization organization

                Nothing ->
                    Element.none
            ]
        ]
    }
