module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (alignLeft, alignRight, alignTop, centerX, column, el, fill, fillPortion, height, link, maximum, padding, paddingXY, paragraph, px, row, spacing, text, textColumn, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FontAwesome exposing (Option(..), Transform(..))
import Head
import Head.Seo as Seo
import Html.Attributes as Attrs
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Service exposing (Category(..))
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
head static =
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


viewFilterLink { hasBorders, isVertical, fontSize } filter =
    let
        ( icon, options, title ) =
            filterDetails filter
    in
    Element.link [ width fill ]
        { url = "/services/" ++ Service.categoryToString filter
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
                            [ Element.el [ Font.center, centerX ] <|
                                Element.html <|
                                    FontAwesome.iconWithOptions icon FontAwesome.Solid ([ FontAwesome.Size (FontAwesome.Mult 2) ] ++ options) []
                            , paragraph [ Font.center, Font.size fontSize ] [ text title ]
                            ]

                    else
                        row [ paddingXY 5 0, width fill ]
                            [ Element.el [ alignRight ] <|
                                Element.html <|
                                    FontAwesome.iconWithOptions icon FontAwesome.Solid ([ FontAwesome.Size (FontAwesome.Mult 2) ] ++ options) []
                            , paragraph
                                [ Font.size fontSize
                                , Font.center
                                , paddingXY 5 0
                                ]
                                [ text title ]
                            ]
                }
        }


filterDetails filter =
    case filter of
        Food ->
            ( FontAwesome.utensils, [], "Food" )

        Housing ->
            ( FontAwesome.home, [], "Housing" )

        PersonalCare ->
            ( FontAwesome.shower, [], "Personal care" )

        RentAndUtilitiesAssistance ->
            ( FontAwesome.moneyCheckAlt, [], "Rent and utilities assistance" )

        MedicalCare ->
            ( FontAwesome.stethoscope, [], "Medical care" )

        MentalHealth ->
            ( FontAwesome.brain, [], "Mental health" )

        AddictionServices ->
            ( FontAwesome.wineBottle, [], "Addiction services" )

        NursingHomesAndHospice ->
            ( FontAwesome.bed, [], "Nursing homes and hospice" )

        DentalAndHearing ->
            ( FontAwesome.tooth, [], "Dental and hearing" )

        HivPrepHepC ->
            ( FontAwesome.ribbon, [], "HIV, PrEP, and Hep C" )

        Transportation ->
            ( FontAwesome.bus, [], "Transportation" )

        Internet ->
            ( FontAwesome.wifi, [], "Internet" )

        Phones ->
            ( FontAwesome.mobile, [], "Phones" )

        LegalAid ->
            ( FontAwesome.balanceScale, [], "Legal aid" )

        DomesticViolence ->
            ( FontAwesome.fistRaised, [ Transform [ Rotate 90 ] ], "Domestic violence" )

        SexualAssault ->
            ( FontAwesome.exclamationTriangle, [], "Sexual assault" )

        IDsAndSSI ->
            ( FontAwesome.idCard, [], "IDs and SSI" )

        JobsAndJobTraining ->
            ( FontAwesome.briefcase, [], "Jobs and job training" )

        AdultEducation ->
            ( FontAwesome.graduationCap, [], "Adult education" )

        TutorsAndMentoring ->
            ( FontAwesome.school, [], "Tutors and mentoring" )

        Childcare ->
            ( FontAwesome.hands, [], "Childcare" )

        ParentingHelp ->
            ( FontAwesome.handHoldingHeart, [], "Parenting help" )

        SeniorsAndDisabilities ->
            ( FontAwesome.wheelchair, [], "Seniors and people with disabilities" )

        LGBTQPlus ->
            ( FontAwesome.flag, [], "LGBTQ+" )

        Veterans ->
            ( FontAwesome.medal, [], "Veterans" )

        ImmigrantsAndRefugees ->
            ( FontAwesome.globeAfrica, [], "Immigrants and refugees" )

        FormerlyIncarcerated ->
            ( FontAwesome.box, [], "Formerly incarcerated" )

        OnSexOffenderRegistry ->
            ( FontAwesome.list, [], "On sex offender registry" )

        PetHelp ->
            ( FontAwesome.dog, [], "Pet help" )

        OutsideOfDavidsonCounty ->
            ( FontAwesome.mapSigns, [], "Outside of Davidson Co." )

        Arts ->
            ( FontAwesome.theaterMasks, [], "Arts" )

        Advocacy ->
            ( FontAwesome.handshake, [], "Advocacy" )


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


viewHelpBanner =
    row
        [ width fill
        ]
        [ column
            [ width fill
            , padding 10
            , Border.width 1
            , Border.rounded 15
            ]
            [ row
                [ width fill
                , spacing 10
                ]
                [ textColumn [ width (fillPortion 20) ]
                    [ paragraph
                        [ width fill
                        , Font.center
                        , Font.size 16
                        ]
                        [ text "Not sure where to start?"
                        ]
                    , paragraph
                        [ width fill
                        , Font.center
                        , Font.size 12
                        ]
                        [ text "Answer questions to help us find the best resources for you." ]
                    ]
                , link [ width (fillPortion 1) ]
                    { url = "/help"
                    , label =
                        Input.button
                            [ Border.width 1
                            , centerX
                            , padding 10
                            ]
                            { label = text "Find help"
                            , onPress = Nothing
                            }
                    }
                ]
            ]
        ]


viewMoreLink =
    link [ alignRight, Font.underline, Font.size 14 ] { url = "/", label = text "More" }


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


viewGroupAlt cellConfig title categories =
    column
        [ width fill
        , padding 10
        , spacing 10
        ]
        [ paragraph [ Font.center ] [ text title ]
        , wrappedRow [ centerX, spacing 10 ] (List.map (viewFilterLink cellConfig) categories)
        ]


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
view maybeUrl sharedModel static =
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
                , viewHelpBanner
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
