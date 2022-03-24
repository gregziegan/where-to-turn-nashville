module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Breadcrumbs
import Browser.Events exposing (onResize)
import Browser.Navigation
import Chrome
import DataSource exposing (DataSource)
import DataSource.Http
import Dict exposing (Dict)
import Element exposing (el, fill, padding, width)
import Element.Font as Font
import FontAwesome
import Html exposing (Html)
import OptimizedDecoder as Decode exposing (Decoder, int)
import OptimizedDecoder.Pipeline exposing (required)
import Organization exposing (Organization)
import Pages.Flags exposing (Flags(..))
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Path exposing (Path)
import Route exposing (Route(..))
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
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | GoBack
    | ToggleMobileMenu
    | SetWindow Int Int


type SharedMsg
    = NoOp


type alias Window =
    { width : Int
    , height : Int
    }


type alias Model =
    { showMobileMenu : Bool
    , navKey : Maybe Browser.Navigation.Key
    , window : Window
    }


windowDecoder : Decoder Window
windowDecoder =
    Decode.succeed Window
        |> required "width" int
        |> required "height" int


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl :
                Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False
      , navKey = navigationKey
      , window =
            case flags of
                BrowserFlags value ->
                    Decode.decodeValue (Decode.field "window" windowDecoder) value
                        |> Result.withDefault { width = 600, height = 1000 }

                PreRenderFlags ->
                    { width = 600, height = 1000 }
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange urlPath ->
            ( { model
                | showMobileMenu = False
              }
            , Cmd.none
            )

        GoBack ->
            ( model
            , case model.navKey of
                Just key ->
                    Browser.Navigation.back key 1

                Nothing ->
                    Cmd.none
            )

        ToggleMobileMenu ->
            ( { model | showMobileMenu = not model.showMobileMenu }, Cmd.none )

        SetWindow width height ->
            ( { model | window = { width = width, height = height } }, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.batch
        [ onResize SetWindow
        ]


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
    let
        device =
            Element.classifyDevice model.window
    in
    { body =
        [ Element.html FontAwesome.useCss
        , Chrome.view
            { device = device
            , showMobileMenu = model.showMobileMenu
            , toggleMobileMenu = ToggleMobileMenu
            }
            |> Element.map toMsg
        , case page.route of
            Just Index ->
                Element.none

            Just _ ->
                Breadcrumbs.view "Back" model.navKey GoBack
                    |> el [ padding 10 ]
                    |> Element.map toMsg

            Nothing ->
                Element.none
        ]
            ++ pageView.body
            |> Element.column
                [ width fill
                , Font.family [ Font.typeface "system" ]
                ]
            |> Element.layout [ width fill ]
    , title = pageView.title
    }
