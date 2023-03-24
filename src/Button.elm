module Button exposing (Config, fullWidth, primary, render, transparent, withIcon, withIconOptions)

import Element exposing (Element, el, fill, padding, px, row, spacing, text, width)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import FontAwesome exposing (Icon, Option)
import Palette


type alias Config msg =
    { attributes : List (Element.Attribute msg)
    , icon : Maybe Icon
    , iconOptions : List Option
    , text : String
    , onPress : Maybe msg
    }


fullWidth : Config msg -> Config msg
fullWidth config =
    { config | attributes = config.attributes ++ [ width fill ] }


attributes : List (Element.Attribute msg)
attributes =
    [ width (px 200) ]


defaultConfig : Config msg
defaultConfig =
    { attributes = attributes
    , icon = Nothing
    , iconOptions = []
    , text = ""
    , onPress = Nothing
    }


withIcon : Icon -> Config msg -> Config msg
withIcon icon config =
    { config | icon = Just icon }


withIconOptions : List Option -> Config msg -> Config msg
withIconOptions options config =
    { config | iconOptions = options }


primary : { a | onPress : Maybe msg, text : String } -> Config msg
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


transparent : { a | text : String } -> Config b
transparent { text } =
    { defaultConfig
        | attributes =
            attributes
                ++ [ padding 10
                   ]
        , onPress = Nothing
        , text = text
    }


render : Config msg -> Element msg
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
                        [ el [] <| Element.html <| FontAwesome.iconWithOptions icon FontAwesome.Solid config.iconOptions []
                        , text config.text
                        ]

                Nothing ->
                    text config.text
        }
