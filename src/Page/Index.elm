module Page.Index exposing (Data, Model, Msg, RouteParams, page)

import DataSource exposing (DataSource)
import Element exposing (Element, alignRight, alignTop, centerX, column, fill, height, link, maximum, padding, paddingXY, paragraph, px, row, spacing, text, textColumn, width, wrappedRow)
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Head
import Head.Seo as Seo
import Html.Attributes as Attrs
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Service exposing (Category)
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "where-to-turn-nashville"
        , image =
            { url = Pages.Url.external "https://where-to-turn-nashville.netlify.app"
            , alt = "Where to turn in Nashville logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "A handbook for our neighbors in need."
        , locale = Nothing
        , title = "Where to turn in Nashville" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    ()


viewFilterLink : { a | hasBorders : Bool, isVertical : Bool, fontSize : Int } -> Category -> Element msg
viewFilterLink { hasBorders, isVertical, fontSize } category =
    let
        branding : Service.Branding
        branding =
            Service.branding category
    in
    Element.link [ width fill ]
        { url = "/services/" ++ Service.categoryToString category
        , label =
            Input.button
                ([ width (px 140)
                 , height (px 100)
                 , spacing 5
                 , padding 10
                 , Element.htmlAttribute (Attrs.attribute "tabindex" "-1")
                 ]
                    ++ (if hasBorders then
                            [ Border.width 1
                            , Border.rounded 15
                            ]

                        else
                            []
                       )
                )
                { onPress = Nothing
                , label =
                    if isVertical then
                        column [ width fill, paddingXY 5 0, spacing 10 ]
                            [ Service.viewIcon branding
                            , paragraph [ Font.center, Font.size fontSize ] [ text branding.title ]
                            ]

                    else
                        row [ paddingXY 5 0, width fill ]
                            [ Service.viewIcon branding
                            , paragraph
                                [ Font.size fontSize
                                , Font.center
                                , paddingXY 5 0
                                ]
                                [ text branding.title ]
                            ]
                }
        }


viewWelcomeBanner : Element msg
viewWelcomeBanner =
    row [ width fill ]
        [ textColumn [ width fill ]
            [ paragraph [ Font.center, Font.size 16 ]
                [ text <| String.toUpper "Where to turn in Nashville"
                ]
            , paragraph [ Font.center, Font.size 12 ]
                [ text <| "A guide to navigating resources in Middle Tennessee" ]
            ]
        ]


viewMoreLink : Element msg
viewMoreLink =
    link [ alignRight, Font.underline, Font.size 14 ] { url = "/", label = text "More" }


viewGroup : CellConfig -> String -> List Category -> Element msg
viewGroup cellConfig title categories =
    column
        [ width fill
        , padding 10
        , Border.width 1
        , Border.rounded 15
        , spacing 10
        ]
        [ paragraph [ paddingXY 5 0 ] [ text title ]
        , wrappedRow
            [ spacing 10
            ]
            (List.map (viewFilterLink cellConfig) categories)
        , viewMoreLink
        ]


viewGroupAlt : CellConfig -> String -> List Category -> Element msg
viewGroupAlt cellConfig title categories =
    column
        [ width fill
        , padding 10
        , spacing 10
        ]
        [ paragraph [ Font.center ] [ text title ]
        , wrappedRow [ centerX, spacing 10 ] (List.map (viewFilterLink cellConfig) categories)
        ]


type alias CellConfig =
    { hasBorders : Bool
    , isVertical : Bool
    , fontSize : Int
    }


defaultCellConfig : CellConfig
defaultCellConfig =
    { hasBorders = True
    , isVertical = True
    , fontSize = 14
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ _ =
    { title = "Where to turn in Nashville"
    , body =
        [ column
            [ alignTop
            , width fill
            , height fill
            , padding 10
            ]
            [ column
                [ width (fill |> maximum 800)
                , spacing 20
                ]
                [ viewWelcomeBanner
                , viewGroup { defaultCellConfig | isVertical = False, fontSize = 12 } "Urgent needs" Service.urgentNeeds
                , viewGroup { defaultCellConfig | fontSize = 12 } "Get care" Service.care
                , viewGroupAlt { defaultCellConfig | hasBorders = False } "Get connected" Service.connectivity
                , viewGroup defaultCellConfig "Get help" Service.help
                , viewGroupAlt defaultCellConfig "Find work" Service.work
                , viewGroup defaultCellConfig "Family and youth resources" Service.familyAndYouth
                , viewGroup { defaultCellConfig | fontSize = 10 } "Resources for" Service.forGroups
                , viewGroupAlt defaultCellConfig "More" Service.other
                ]
            ]
        ]
    }
