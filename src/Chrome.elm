module Chrome exposing (view)

import Element exposing (Device, DeviceClass(..), Element, alignLeft, alignRight, centerX, fill, height, padding, paragraph, px, row, spacing, text, width)
import Element.Font as Font
import Element.Input as Input
import FontAwesome exposing (Style(..))


menuButton toggleMenu =
    Input.button [] { onPress = Just toggleMenu, label = Element.el [] <| Element.html <| FontAwesome.icon FontAwesome.bars }


logo =
    Element.link []
        { url = "/"
        , label = Element.image [ width (px 60), height (px 60) ] { src = "/images/otn-logo.jpg", description = "Open Table Nashville logo" }
        }


starredLink =
    Element.link [] { url = "/starred", label = Element.el [] <| Element.html <| FontAwesome.icon FontAwesome.star }


searchLink =
    Element.link []
        { url = "/search"
        , label = Element.el [] <| Element.html <| FontAwesome.icon FontAwesome.search
        }


view : { device : Device, showMobileMenu : Bool, toggleMobileMenu : msg } -> Element msg
view { device, showMobileMenu, toggleMobileMenu } =
    row
        [ width fill
        , spacing 5
        , padding 10
        ]
        [ case device.class of
            Phone ->
                menuButton toggleMobileMenu

            Tablet ->
                menuButton toggleMobileMenu

            Desktop ->
                Element.none

            BigDesktop ->
                Element.none
        , Element.el [ centerX ] searchLink
        , Element.el [ centerX ] starredLink
        , Element.el [] logo
        ]
