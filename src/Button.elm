module Button exposing (Config, fullWidth, primary, render, transparent, withIcon)

import Element exposing (el, fill, padding, px, row, spacing, text, width)
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


fullWidth config =
    { config | attributes = config.attributes ++ [ width fill ] }


attributes =
    [ width (px 200) ]


defaultConfig =
    { attributes = attributes
    , icon = Nothing
    , text = ""
    , onPress = Nothing
    }


withIcon icon config =
    { config | icon = Just icon }


primary { onPress, text } =
    { defaultConfig
        | attributes =
            attributes
                ++ [ Background.color Palette.gray
                   , padding 10
                   , Font.color Palette.white
                   ]
        , onPress = onPress
        , text = text
    }


transparent { text } =
    { defaultConfig
        | attributes =
            attributes
                ++ [ padding 10
                   ]
        , onPress = Nothing
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
