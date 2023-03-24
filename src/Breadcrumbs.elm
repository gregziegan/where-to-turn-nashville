module Breadcrumbs exposing (view)

import Browser.Navigation
import Element exposing (Element, el, paragraph, row, spacing, text)
import Element.Input as Input
import FontAwesome


view : String -> Maybe Browser.Navigation.Key -> msg -> Element msg
view label key onPress =
    case key of
        Just _ ->
            Input.button []
                { onPress = Just onPress
                , label =
                    row [ spacing 10 ]
                        [ el [] <| Element.html <| FontAwesome.icon FontAwesome.arrowLeft
                        , paragraph [] [ text label ]
                        ]
                }

        Nothing ->
            Element.none
