module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (alignLeft, alignRight, alignTop, centerX, column, el, fill, fillPortion, height, link, maximum, padding, paddingXY, paragraph, px, row, spacing, text, textColumn, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FontAwesome
import Head
import Head.Seo as Seo
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


viewFilterLink filter =
    let
        ( icon, title ) =
            filterDetails filter
    in
    Element.link [ width fill ]
        { url = "/services/" ++ Service.categoryToString filter
        , label =
            Input.button
                [ width (px 150)
                , height (px 100)
                , Border.width 1
                , Border.rounded 15
                , spacing 5
                , padding 10
                ]
                { onPress = Nothing
                , label =
                    row [ width fill, centerX, spacing 10 ]
                        [ Element.el [] <|
                            Element.html <|
                                FontAwesome.iconWithOptions icon FontAwesome.Solid [ FontAwesome.Size (FontAwesome.Mult 2) ] []
                        , paragraph [ Font.size 14, Font.alignRight ] [ text title ]
                        ]
                }
        }


filterDetails filter =
    case filter of
        Food ->
            ( FontAwesome.utensils, "Food" )

        Housing ->
            ( FontAwesome.bed, "Housing" )

        PersonalCare ->
            ( FontAwesome.shower, "Personal care" )

        RentAndUtilitiesAssistance ->
            ( FontAwesome.creditCard, "Rent and utilities assistance" )

        MedicalCare ->
            ( FontAwesome.medkit, "Medical care" )

        MentalHealth ->
            ( FontAwesome.notesMedical, "Mental health" )

        AddictionServices ->
            ( FontAwesome.prescriptionBottle, "Addiction services" )

        NursingHomesAndHospice ->
            ( FontAwesome.bed, "Nursing homes and hospice" )

        DentalAndHearing ->
            ( FontAwesome.tooth, "Dental and hearing" )

        HivPrepHepC ->
            ( FontAwesome.ribbon, "HIV, PrEP, and Hep C" )

        Transportation ->
            ( FontAwesome.bus, "Transportation" )

        Internet ->
            ( FontAwesome.wifi, "Internet" )

        Phones ->
            ( FontAwesome.phone, "Phones" )

        LegalAid ->
            ( FontAwesome.balanceScale, "Legal aid" )

        DomesticViolence ->
            ( FontAwesome.exclamationTriangle, "Domestic violence" )

        SexualAssault ->
            ( FontAwesome.exclamationTriangle, "Sexual assault" )

        IDsAndSSI ->
            ( FontAwesome.idCard, "IDs and SSI" )

        JobsAndJobTraining ->
            ( FontAwesome.briefcase, "Jobs and job training" )

        AdultEducation ->
            ( FontAwesome.school, "Adult education" )

        TutorsAndMentoring ->
            ( FontAwesome.school, "Tutors and mentoring" )

        Childcare ->
            ( FontAwesome.hands, "Childcare" )

        ParentingHelp ->
            ( FontAwesome.handHoldingBox, "Parenting help" )

        SeniorsAndDisabilities ->
            ( FontAwesome.wheelchair, "Seniors and people with disabilities" )

        LGBTQPlus ->
            ( FontAwesome.flag, "LGBTQ+" )

        Veterans ->
            ( FontAwesome.medal, "Veterans" )

        ImmigrantsAndRefugees ->
            ( FontAwesome.globeAfrica, "Immigrants and refugees" )

        FormerlyIncarcerated ->
            ( FontAwesome.box, "Formerly incarcerated" )

        OnSexOffenderRegistry ->
            ( FontAwesome.list, "On sex offender registry" )

        PetHelp ->
            ( FontAwesome.deployDog, "Pet help" )

        OutsideOfDavidsonCounty ->
            ( FontAwesome.mapSigns, "Outside of Davidson Co." )

        Arts ->
            ( FontAwesome.play, "Arts" )

        Advocacy ->
            ( FontAwesome.handshake, "Advocacy" )


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


viewGroup title categories =
    column
        [ width fill
        , padding 20
        , Border.width 1
        , Border.rounded 15
        , spacing 10
        ]
        [ paragraph [] [ text title ]
        , wrappedRow [ spacing 10 ] (List.map viewFilterLink categories)
        ]


viewGroupAlt title categories =
    column
        [ width fill
        , padding 20
        , spacing 10
        ]
        [ paragraph [ Font.center ] [ text title ]
        , wrappedRow [ centerX, spacing 10 ] (List.map viewFilterLink categories)
        ]


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
                , viewGroup "Urgent needs" Service.urgentNeeds
                , viewGroup "Get care" Service.care
                , viewGroupAlt "Get connected" Service.connectivity
                , viewGroup "Get help" Service.help
                , viewGroupAlt "Find work" Service.work
                , viewGroup "Family and youth resources" Service.familyAndYouth
                , viewGroup "Resources for" Service.forGroups
                , viewGroupAlt "More" Service.other
                ]
            ]
        ]
    }
