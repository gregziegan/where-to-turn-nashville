module Page.Services.Detail.Id_ exposing (Data, Model, Msg, page)

import Button
import DataSource exposing (DataSource)
import DataSource.Http
import Dict
import Element exposing (centerX, column, fill, link, maximum, padding, paragraph, row, spacing, text, textColumn, width)
import Element.Font as Font
import Element.Input as Input
import FontAwesome exposing (fontAwesome)
import Head
import Head.Seo as Seo
import OptimizedDecoder as Decode
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Pages.Url
import QueryParams
import Shared
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
            (\apiKey -> "https://sheets.googleapis.com/v4/spreadsheets/10tGJn9MCEJ10CraGIf7HP57phJ4FF5Jkw--JwOmkvA0/values/Combined!A2:P?key=" ++ apiKey ++ "&valueRenderOption=UNFORMATTED_VALUE")
            |> Secrets.with "GOOGLE_API_KEY"
        )
        (Decode.field "values"
            (Decode.list (Decode.index 0 Decode.int |> Decode.map (String.fromInt >> RouteParams)))
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


viewLogo service =
    text "blank image"


viewNameAndDescription service =
    textColumn [ width fill ]
        [ paragraph [ width fill ] [ text service.name ]
        , paragraph [ width fill ] [ text service.description ]
        ]


directionsLink =
    link []
        { url = "/"
        , label =
            Button.primary
                { onPress = Nothing
                , text = "Directions"
                }
                |> Button.withIcon FontAwesome.mapMarker
                |> Button.render
        }


saveLink =
    link []
        { url = "/"
        , label =
            Button.primary
                { onPress = Nothing
                , text = "Save"
                }
                |> Button.withIcon FontAwesome.star
                |> Button.render
        }


messageLink =
    link []
        { url = "/"
        , label =
            Button.primary
                { onPress = Nothing
                , text = "Message"
                }
                |> Button.withIcon FontAwesome.envelope
                |> Button.render
        }


callLink =
    link []
        { url = "/"
        , label =
            Button.primary
                { onPress = Nothing
                , text = "Call"
                }
                |> Button.withIcon FontAwesome.phone
                |> Button.render
        }


viewService service =
    column [ width fill, spacing 10 ]
        [ row [ width fill ]
            [ viewLogo service
            , viewNameAndDescription service
            ]
        , row [ width fill, spacing 10 ]
            [ directionsLink
            , saveLink
            , messageLink
            , callLink
            ]
        ]


currentService services params =
    let
        maybeService =
            params.id
                |> String.toInt
                |> Maybe.andThen (\id -> List.head <| List.filter ((==) id << .id) services)
    in
    case maybeService of
        Just service ->
            viewService service

        Nothing ->
            text "not found"


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
            [ currentService static.sharedData static.routeParams
            ]
        ]
    }
