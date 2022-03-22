module Button exposing (Config, primary, render, withIcon)

import Element exposing (el, fill, padding, row, spacing, text, width)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import FontAwesome exposing (Icon)
import Palette


type alias Config msg =
    { attributes : Element.Attribute msg
    , icon : Maybe Icon
    , text : String
    , onPress : Maybe msg
    }


defaultConfig =
    { attributes = []
    , icon = Nothing
    , text = ""
    , onPress = Nothing
    }


withIcon icon config =
    { config | icon = Just icon }


primary { onPress, text } =
    { defaultConfig
        | attributes =
            [ Background.color Palette.gray
            , padding 10
            , Font.color Palette.white
            ]
        , onPress = onPress
        , text = text
    }


render config =
    Input.button
        config.attributes
        { onPress = config.onPress
        , label =
            case config.icon of
                Just icon ->
                    row
                        [ width fill
                        , spacing 10
                        ]
                        [ el [] <| Element.html <| FontAwesome.icon icon
                        , text config.text
                        ]

                Nothing ->
                    text config.text
        }
