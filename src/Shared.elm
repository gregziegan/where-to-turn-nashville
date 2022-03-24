module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Breadcrumbs exposing (UrlPath)
import Browser.Navigation
import Chrome
import DataSource exposing (DataSource)
import DataSource.Http
import Dict exposing (Dict)
import Element exposing (fill, width)
import Element.Font as Font
import FontAwesome
import Html exposing (Html)
import OptimizedDecoder as Decode
import Organization exposing (Organization)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Path exposing (Path)
import Route exposing (Route)
import Service exposing (Service)
import SharedTemplate exposing (SharedTemplate)
import Spreadsheet
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange UrlPath
    | ToggleMobileMenu


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    , history : List UrlPath
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path : UrlPath
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False
      , history = []
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange urlPath ->
            ( { model
                | showMobileMenu = False
                , history = List.take 10 <| urlPath :: model.history
              }
            , Cmd.none
            )

        ToggleMobileMenu ->
            ( { model | showMobileMenu = not model.showMobileMenu }, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


type alias Data =
    { services : Dict Int Service
    , organizations : Dict Int Organization
    }


toDict entities =
    entities
        |> List.map (\e -> ( e.id, e ))
        |> Dict.fromList


data : DataSource Data
data =
    DataSource.map2
        Data
        (DataSource.Http.get
            (Secrets.succeed
                (Spreadsheet.url Service.sheetId "A2:P")
                |> Secrets.with "GOOGLE_API_KEY"
            )
            (Decode.field "values"
                (Decode.list Service.decoder |> Decode.map toDict)
            )
        )
        (DataSource.Http.get
            (Secrets.succeed
                (Spreadsheet.url Organization.sheetId "A2:P")
                |> Secrets.with "GOOGLE_API_KEY"
            )
            (Decode.field "values"
                (Decode.list Organization.decoder |> Decode.map toDict)
            )
        )


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    { body =
        [ Element.html FontAwesome.useCss
        , Chrome.view
            { isMobile = False
            , showMobileMenu = model.showMobileMenu
            , toggleMobileMenu = ToggleMobileMenu
            }
            |> Element.map toMsg
        ]
            ++ pageView.body
            |> Element.column
                [ width fill
                , Font.family [ Font.typeface "system" ]
                ]
            |> Element.layout [ width fill ]
    , title = pageView.title
    }
