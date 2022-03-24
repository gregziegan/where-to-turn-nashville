module Breadcrumbs exposing (view)

import Browser.Navigation
import Element exposing (Element, el, link, paragraph, row, spacing, text)
import Element.Input
import FontAwesome
import Path exposing (Path)


view : String -> Maybe Browser.Navigation.Key -> msg -> Element msg
view label key onPress =
    case key of
        Just _ ->
            Element.Input.button []
                { onPress = Just onPress
                , label =
                    row [ spacing 10 ]
                        [ el [] <| Element.html <| FontAwesome.icon FontAwesome.arrowLeft
                        , paragraph [] [ text label ]
                        ]
                }

        Nothing ->
            Element.none
