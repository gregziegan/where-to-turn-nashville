module Chrome exposing (Config, view)

import Breadcrumbs
import Browser.Navigation
import Element exposing (Device, DeviceClass(..), Element, alignRight, alignTop, centerX, clipY, column, el, fill, fillPortion, height, link, maximum, minimum, padding, paddingXY, paragraph, px, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FontAwesome
import Html.Attributes as Attrs
import Link
import Palette
import Path exposing (Path)
import Route exposing (Route(..))
import Search
import Service exposing (Category(..))
import Util
import Window exposing (Window)


menuButton : msg -> Element msg
menuButton toggleMenu =
    Input.button [] { onPress = Just toggleMenu, label = Element.el [] <| Element.html <| FontAwesome.icon FontAwesome.bars }


logo : Element msg
logo =
    Element.link []
        { url = "/"
        , label = Element.image [ width (px 60), height (px 60) ] { src = "/images/otn-logo.jpg", description = "Open Table Nashville logo" }
        }


viewMenuDrawer : Window -> msg -> Element msg
viewMenuDrawer window toggleMenu =
    column
        [ width fill
        , height (px window.height)
        , Background.color Palette.gray
        , Element.htmlAttribute (Attrs.style "z-index" "1")
        , Element.inFront
            (column
                [ width (fill |> minimum 250 |> maximum (window.width * 5 // 6))
                , Background.color Palette.white
                , paddingXY 10 20
                , Element.htmlAttribute (Attrs.style "z-index" "2")
                , Border.width 2
                , spacing 5
                , height fill
                , scrollbarY
                ]
                [ row [ width fill, padding 5 ]
                    [ Input.button [ alignRight ]
                        { onPress = Just toggleMenu
                        , label = el [] <| Element.html <| FontAwesome.icon FontAwesome.bars
                        }
                    ]
                , row [ width fill ] [ viewMenu ]
                ]
            )
        ]
        []


viewMenuLink : Element msg -> Element msg
viewMenuLink aLink =
    row [ width fill, padding 10 ] [ aLink ]


resourceLinks : List (Element msg)
resourceLinks =
    [ Link.resource SeniorsAndDisabilities
    , Link.resource Housing
    , Link.resource Food
    , Link.resource PersonalCare
    , Link.resource RentAndUtilitiesAssistance
    , Link.resource MedicalCare
    , Link.resource JobsAndJobTraining
    , Link.resource LegalAid
    , Link.resource DomesticViolence
    , Link.resource Transportation
    , Link.resource Phones
    , Link.resource PetHelp
    , Link.resource Arts
    , Link.resource Advocacy
    , Link.resource OutsideOfDavidsonCounty
    ]


viewMenu : Element msg
viewMenu =
    column [ width fill ]
        [ viewMenuLink <| Link.menu "Home" "/"
        , row [ width fill, padding 10 ]
            [ column [ width fill ]
                [ paragraph [ Font.bold ] [ text "Resources" ]
                , column
                    [ width fill
                    , padding 10
                    ]
                    (List.map viewMenuLink resourceLinks)
                ]
            ]
        , viewMenuLink <| Link.menu "Order the guide" "/"
        , viewMenuLink <| Link.menu "Add or edit a listing" "/"
        , viewMenuLink <| Link.menu "About" "/"
        , viewMenuLink <| Link.menu "Other resources" "/"
        , viewMenuLink <| Link.menu "My Saved" "/saved"
        ]


viewPersistentMenu : Config msg -> Element msg
viewPersistentMenu _ =
    column
        [ width (fillPortion 1)
        , alignTop
        , height fill

        -- , Border.widthEach { top = 0, bottom = 0, right = 1, left = 0 }
        ]
        [ viewMenu ]


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


viewBackLink : Config msg -> Element msg
viewBackLink { goBack, navKey, page } =
    case page.route of
        Just Index ->
            Element.none

        Just _ ->
            Breadcrumbs.view "Back" navKey goBack
                |> el [ padding 10 ]

        Nothing ->
            Element.none


viewMobile : Config msg -> Element msg
viewMobile config =
    column
        [ width (fill |> maximum config.window.width)
        ]
        (viewNavBar True config
            :: Util.renderIf config.showMobileSearch
                (Element.el
                    [ width fill
                    , paddingXY 20 10
                    ]
                    (Search.box config.searchConfig)
                )
            :: viewBackLink config
            :: config.content
        )


navBarHeight : number
navBarHeight =
    80


viewNavBar : Bool -> Config msg -> Element msg
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
        [ Util.renderIf isMobile (menuButton toggleMobileMenu)
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
            [ Element.el [ alignRight ] logo
            ]
        ]


paneHeight : Config msg -> Int
paneHeight config =
    config.window.height - navBarHeight


viewPanes : Config msg -> Element msg
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


viewDesktop : Config msg -> Element msg
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
