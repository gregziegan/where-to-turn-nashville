module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import Chrome
import DataSource exposing (DataSource)
import DataSource.Http
import Element exposing (fill, width)
import Element.Font
import FontAwesome
import Html exposing (Html)
import OptimizedDecoder as Decode
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Path exposing (Path)
import Route exposing (Route)
import Service exposing (Service)
import SharedTemplate exposing (SharedTemplate)
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
    | ToggleMobileMenu


type alias Data =
    List Service


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
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
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange url ->
            ( { model | showMobileMenu = False }, Cmd.none )

        ToggleMobileMenu ->
            ( { model | showMobileMenu = not model.showMobileMenu }, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource (List Service)
data =
    DataSource.Http.get
        (Secrets.succeed
            (\apiKey ->
                "https://sheets.googleapis.com/v4/spreadsheets/10tGJn9MCEJ10CraGIf7HP57phJ4FF5Jkw--JwOmkvA0/values/Combined!A2:P?key=" ++ apiKey ++ "&valueRenderOption=UNFORMATTED_VALUE"
            )
            |> Secrets.with "GOOGLE_API_KEY"
        )
        (Decode.field "values"
            (Decode.list Service.decoder)
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
                , Element.Font.family [ Element.Font.typeface "system" ]
                ]
            |> Element.layout [ width fill ]
    , title = pageView.title
    }
