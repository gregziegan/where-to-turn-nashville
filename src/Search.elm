module Search exposing (Config, allServicesAdded, box, fromCache)

import Element exposing (Device, DeviceClass(..), Element, alignLeft, alignRight, centerX, column, el, fill, height, link, maximum, padding, paddingXY, paragraph, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import ElmTextSearch exposing (Index)
import ElmTextSearch.Json.Decoder
import FontAwesome
import Html.Events
import Json.Decode as Decode exposing (Decoder, Error)
import Json.Encode exposing (Value)
import Service exposing (Service)


serviceConfig : ElmTextSearch.SimpleConfig Service
serviceConfig =
    { ref = String.fromInt << .id
    , fields =
        [ ( .organizationName, 5.0 )
        , ( .description, 1.0 )
        ]
    , listFields = []
    }


serviceIndex : ElmTextSearch.Index Service
serviceIndex =
    ElmTextSearch.new serviceConfig


allServicesAdded : List Service -> ( ElmTextSearch.Index Service, List ( Int, String ) )
allServicesAdded services =
    ElmTextSearch.addDocs
        services
        serviceIndex


type alias Config msg =
    { onChange : String -> msg
    , onSearch : msg
    , query : String
    }


onEnter : msg -> Element.Attribute msg
onEnter msg =
    Element.htmlAttribute
        (Html.Events.on "keyup"
            (Decode.field "key" Decode.string
                |> Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Decode.succeed msg

                        else
                            Decode.fail "Not the enter key"
                    )
            )
        )


box : Config msg -> Element msg
box config =
    row
        [ padding 10
        , spacing 10
        , onEnter config.onSearch
        ]
        [ FontAwesome.icon FontAwesome.search
            |> Element.html
            |> Element.el []
        , Input.search []
            { onChange = config.onChange
            , text = config.query
            , label = Input.labelHidden "Search"
            , placeholder =
                Just
                    (Input.placeholder [] (text "Search for a service or organization"))
            }
        ]


fromCache : Maybe String -> Maybe (Index Service)
fromCache str =
    Maybe.andThen (Result.toMaybe << ElmTextSearch.fromString serviceConfig) str
