module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Events exposing (onResize)
import Browser.Navigation
import Chrome
import DataSource exposing (DataSource)
import DataSource.Http
import Dict exposing (Dict)
import Element exposing (DeviceClass(..), el, fill, padding, width)
import Element.Font as Font
import ElmTextSearch
import FontAwesome
import Html exposing (Html)
import OptimizedDecoder as Decode exposing (Decoder, int)
import OptimizedDecoder.Pipeline exposing (required)
import Organization exposing (Organization)
import Pages.Flags exposing (Flags(..))
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Path exposing (Path)
import QueryParams
import Route exposing (Route(..))
import Search
import Service exposing (Service)
import SharedTemplate exposing (SharedTemplate)
import Spreadsheet
import View exposing (View)
import Window exposing (Window)


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
    | ToggleMobileSearch
    | SetWindow Int Int
    | OnSearchChange String
    | OnSearch


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    , showMobileSearch : Bool
    , navKey : Maybe Browser.Navigation.Key
    , window : Window
    , searchQuery : Maybe String
    }


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
      , showMobileSearch = False
      , navKey = navigationKey
      , window =
            case flags of
                BrowserFlags value ->
                    Decode.decodeValue (Decode.field "window" Window.decoder) value
                        |> Result.withDefault { width = 600, height = 1000 }

                PreRenderFlags ->
                    { width = 600, height = 1000 }
      , searchQuery =
            maybePagePath
                |> Maybe.andThen .pageUrl
                |> Maybe.andThen .query
                |> Maybe.map QueryParams.toDict
                |> Maybe.andThen (Dict.get "search")
                |> Maybe.andThen List.head
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

        ToggleMobileSearch ->
            ( { model | showMobileSearch = not model.showMobileSearch }, Cmd.none )

        SetWindow width height ->
            ( { model | window = { width = width, height = height } }, Cmd.none )

        OnSearchChange query ->
            ( { model | searchQuery = Just query }, Cmd.none )

        OnSearch ->
            case model.searchQuery of
                Just query ->
                    ( model
                    , case model.navKey of
                        Just key ->
                            Browser.Navigation.pushUrl key ("/services?search=" ++ query)

                        Nothing ->
                            Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.batch
        [ onResize SetWindow
        ]


type alias Data =
    ()


data : DataSource Data
data =
    DataSource.succeed ()


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
            , toggleMobileMenu = toMsg ToggleMobileMenu
            , window = model.window
            , searchConfig =
                { onChange = toMsg << OnSearchChange
                , onSearch = toMsg OnSearch
                , query = Maybe.withDefault "" model.searchQuery
                , toggleMobile = toMsg ToggleMobileSearch
                }
            , navKey = model.navKey
            , page = page
            , goBack = toMsg GoBack
            , showMobileSearch = model.showMobileSearch
            , content = pageView.body
            }

        -- |> Element.map toMsg
        ]
            |> Element.column
                [ width fill
                , Font.family [ Font.typeface "system" ]
                ]
            |> Element.layout [ width fill ]
    , title = pageView.title
    }
