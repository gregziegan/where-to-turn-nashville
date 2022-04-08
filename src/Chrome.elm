module Chrome exposing (Config, view)

import Breadcrumbs
import Browser.Navigation
import Element exposing (Device, DeviceClass(..), Element, alignLeft, alignRight, alignTop, centerX, clipY, column, el, fill, fillPortion, height, link, maximum, padding, paddingXY, paragraph, px, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FontAwesome exposing (Style(..))
import Html.Attributes as Attrs
import Palette
import Path exposing (Path)
import Route exposing (Route(..))
import Search
import Window exposing (Window)


menuButton toggleMenu =
    Input.button [] { onPress = Just toggleMenu, label = Element.el [] <| Element.html <| FontAwesome.icon FontAwesome.bars }


logo =
    Element.link []
        { url = "/"
        , label = Element.image [ width (px 60), height (px 60) ] { src = "/images/otn-logo.jpg", description = "Open Table Nashville logo" }
        }


starredLink =
    Element.link []
        { url = "/starred"
        , label = Element.el [] <| Element.html <| FontAwesome.icon FontAwesome.star
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
        , Element.htmlAttribute (Attrs.style "z-index" "1")
        , Element.inFront
            (column
                [ width (fill |> maximum 250)
                , Background.color Palette.white
                , paddingXY 10 20
                , Element.htmlAttribute (Attrs.style "z-index" "2")
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


viewPersistentMenu config =
    column
        [ width (fillPortion 1)
        , alignTop
        , height fill

        -- , Border.widthEach { top = 0, bottom = 0, right = 1, left = 0 }
        ]
        (List.map viewMenuLink menuLinks)


type alias Config msg =
    { device : Device
    , showMobileMenu : Bool
    , toggleMobileMenu : msg
    , window : Window
    , searchConfig : Search.Config msg
    , navKey : Maybe Browser.Navigation.Key
    , page :
        { path : Path
        , route : Maybe Route
        }
    , goBack : msg
    , content : List (Element msg)
    , showMobileSearch : Bool
    }


viewBackLink { goBack, navKey, page } =
    case page.route of
        Just Index ->
            Element.none

        Just _ ->
            Breadcrumbs.view "Back" navKey goBack
                |> el [ padding 10 ]

        Nothing ->
            Element.none


viewMobile config =
    column
        [ width (fill |> maximum config.window.width)
        ]
        (viewNavBar True config
            :: (if config.showMobileSearch then
                    Element.el
                        [ width fill
                        , paddingXY 20 10
                        ]
                        (Search.box config.searchConfig)

                else
                    Element.none
               )
            :: config.content
        )


navBarHeight =
    80


viewNavBar isMobile { window, showMobileMenu, toggleMobileMenu, searchConfig } =
    row
        ([ width fill
         , height (px navBarHeight)
         , padding 10
         , alignTop
         , Element.htmlAttribute (Attrs.style "position" "sticky")
         , Element.htmlAttribute (Attrs.style "top" "0")
         , Element.htmlAttribute (Attrs.style "left" "0")
         , Element.htmlAttribute (Attrs.style "z-index" "1")
         , Background.color Palette.white
         , Border.widthEach { top = 0, bottom = 1, left = 0, right = 0 }
         ]
            ++ (if isMobile && showMobileMenu then
                    [ Element.inFront (viewMenuDrawer window toggleMobileMenu) ]

                else
                    []
               )
        )
        [ if isMobile then
            menuButton toggleMobileMenu

          else
            Element.none
        , if isMobile then
            Element.el
                [ width fill
                , padding 10
                ]
                (Element.el [ alignRight ] (Search.button searchConfig))

          else
            Element.el
                [ width (fill |> maximum 600)
                , padding 10
                , centerX
                ]
                (Search.box searchConfig)
        , row
            [ width (fill |> maximum 300)
            , spacing 10
            , height fill
            , alignRight
            ]
            [ Element.el [ alignRight ] starredLink
            , Element.el [] logo
            ]
        ]


paneHeight config =
    config.window.height - navBarHeight


viewPanes config =
    row
        [ width fill
        , padding 10
        , spacing 10
        , height (px (paneHeight config))
        ]
        [ viewPersistentMenu config
        , column
            [ width <| fillPortion 3
            , height fill
            , clipY
            , scrollbarY
            ]
            (viewBackLink config :: config.content)
        ]


viewDesktop config =
    column
        [ width fill

        -- , height (fill |> maximum config.window.height)
        ]
        [ viewNavBar False config
        , viewPanes config
        ]


view : Config msg -> Element msg
view config =
    case config.device.class of
        Phone ->
            viewMobile config

        Tablet ->
            viewMobile config

        Desktop ->
            viewDesktop config

        BigDesktop ->
            viewDesktop config
