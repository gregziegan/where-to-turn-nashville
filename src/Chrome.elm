module Chrome exposing (view)

import Element exposing (alignLeft, alignRight, fill, padding, row, spacing, text, width)
import Element.Input as Input
import FontAwesome


menuButton toggleMenu =
    Input.button [] { onPress = Just toggleMenu, label = Element.el [] <| Element.html <| FontAwesome.icon FontAwesome.bars }


logo =
    Element.link [] { url = "/", label = text "Where to turn in Nashville" }


starredLink =
    Element.link [] { url = "/starred", label = Element.el [] <| Element.html <| FontAwesome.icon FontAwesome.star }


view { isMobile, showMobileMenu, toggleMobileMenu } =
    row
        [ width fill
        , spacing 5
        , padding 10
        ]
        [ if isMobile then
            menuButton toggleMobileMenu

          else
            Element.none
        , Element.el [ alignLeft ] logo
        , Element.el [ alignRight ] starredLink
        ]
