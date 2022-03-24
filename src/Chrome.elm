module Chrome exposing (view)

import Button
import Element exposing (Device, DeviceClass(..), Element, alignLeft, alignRight, centerX, column, el, fill, height, link, maximum, padding, paddingXY, paragraph, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FontAwesome exposing (Style(..))
import Html.Attributes
import Palette
import Window exposing (Window)


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


menuLink label path =
    link [ width fill ]
        { url = path
        , label = text label
        }


menuLinks =
    [ menuLink "Home" "/"
    , menuLink "Order the guide" "/"
    , menuLink "Add or edit a listing" "/"
    , menuLink "About" "/"
    , menuLink "Other resources" "/"
    , menuLink "My Saved" "/saved"
    ]


viewMenuLink aLink =
    row
        [ padding 10
        , width fill
        ]
        [ aLink ]


viewMenuDrawer window toggleMenu =
    column
        [ width fill
        , height (px window.height)
        , Background.color Palette.gray
        , Element.htmlAttribute (Html.Attributes.style "z-index" "1")
        , Element.inFront
            (column
                [ width (fill |> maximum 250)
                , Background.color Palette.white
                , paddingXY 10 20
                , Element.htmlAttribute (Html.Attributes.style "z-index" "2")
                , Border.width 2
                , spacing 5
                , height fill
                ]
                (row [ width fill, padding 5 ]
                    [ text "Menu"
                    , Input.button [ alignRight ]
                        { onPress = Just toggleMenu
                        , label = el [] <| Element.html <| FontAwesome.icon FontAwesome.bars
                        }
                    ]
                    :: List.map viewMenuLink menuLinks
                )
            )
        ]
        []


view : { device : Device, showMobileMenu : Bool, toggleMobileMenu : msg, window : Window } -> Element msg
view { device, showMobileMenu, toggleMobileMenu, window } =
    row
        ([ width fill
         , spacing 5
         , padding 10
         ]
            ++ (if showMobileMenu then
                    [ Element.inFront (viewMenuDrawer window toggleMobileMenu) ]

                else
                    []
               )
        )
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
