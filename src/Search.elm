module Search exposing (Config, allServicesAdded, box, button)

import Element exposing (Element, fill, px, row, spacing, text, width)
import Element.Input as Input
import ElmTextSearch
import FontAwesome
import Html.Events
import Json.Decode as Decode
import Service exposing (Service)


serviceIndex : ElmTextSearch.Index Service
serviceIndex =
    ElmTextSearch.new
        { ref = String.fromInt << .id
        , fields =
            [ ( .organizationName, 5.0 )
            , ( .description, 1.0 )
            ]
        , listFields = []
        }


allServicesAdded : List Service -> ( ElmTextSearch.Index Service, List ( Int, String ) )
allServicesAdded services =
    ElmTextSearch.addDocs
        services
        serviceIndex


type alias Config msg =
    { onChange : String -> msg
    , onSearch : msg
    , query : String
    , toggleMobile : msg
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


button : Config msg -> Element msg
button { toggleMobile } =
    Input.button
        [ width (px 35) ]
        { label = viewIcon
        , onPress = Just toggleMobile
        }


viewIcon : Element msg
viewIcon =
    FontAwesome.icon FontAwesome.search
        |> Element.html
        |> Element.el [ width (px 20) ]


box : Config msg -> Element msg
box config =
    row
        [ spacing 10
        , width fill
        , onEnter config.onSearch
        ]
        [ viewIcon
        , Input.search [ width fill ]
            { onChange = config.onChange
            , text = config.query
            , label = Input.labelHidden "Search"
            , placeholder =
                Just
                    (Input.placeholder [] (text "Search for a service or organization"))
            }
        ]
