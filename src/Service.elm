module Service exposing (Category(..), Service, care, categories, categoryFromString, categoryToString, connectivity, decoder, familyAndYouth, forGroups, help, largeListItem, listItem, other, sheetId, sheetRange, urgentNeeds, work)

import Element exposing (Element, column, el, fill, height, link, maximum, minimum, padding, paragraph, px, row, spaceEvenly, spacing, text, textColumn, width)
import Element.Border as Border
import Element.Font as Font
import FontAwesome
import OptimizedDecoder as Decode exposing (Decoder, string)
import OptimizedDecoder.Pipeline exposing (custom, decode, hardcoded)
import Schedule exposing (Schedule)


sheetId : String
sheetId =
    "Services"


sheetRange : String
sheetRange =
    "A2:H"


type Category
    = Food
    | Housing
    | PersonalCare
    | RentAndUtilitiesAssistance
    | MedicalCare
    | MentalHealth
    | AddictionServices
    | NursingHomesAndHospice
    | DentalAndHearing
    | HivPrepHepC
    | Transportation
    | Internet
    | Phones
    | LegalAid
    | DomesticViolence
    | SexualAssault
    | IDsAndSSI
    | JobsAndJobTraining
    | AdultEducation
    | TutorsAndMentoring
    | Childcare
    | ParentingHelp
    | SeniorsAndDisabilities
    | LGBTQPlus
    | Veterans
    | ImmigrantsAndRefugees
    | FormerlyIncarcerated
    | OnSexOffenderRegistry
    | PetHelp
    | OutsideOfDavidsonCounty
    | Arts
    | Advocacy


categories : List Category
categories =
    urgentNeeds ++ care ++ connectivity ++ help ++ work ++ familyAndYouth ++ forGroups ++ other


urgentNeeds : List Category
urgentNeeds =
    [ Food, Housing, PersonalCare, RentAndUtilitiesAssistance ]


care : List Category
care =
    [ MedicalCare, MentalHealth, AddictionServices, NursingHomesAndHospice, DentalAndHearing, HivPrepHepC ]


connectivity : List Category
connectivity =
    [ Transportation, Internet, Phones ]


help : List Category
help =
    [ LegalAid, DomesticViolence, SexualAssault, IDsAndSSI ]


work : List Category
work =
    [ JobsAndJobTraining, AdultEducation ]


familyAndYouth : List Category
familyAndYouth =
    [ TutorsAndMentoring, Childcare, ParentingHelp ]


forGroups : List Category
forGroups =
    [ SeniorsAndDisabilities, LGBTQPlus, Veterans, ImmigrantsAndRefugees, FormerlyIncarcerated, OnSexOffenderRegistry ]


other : List Category
other =
    [ PetHelp, OutsideOfDavidsonCounty, Arts, Advocacy ]


categoryToString : Category -> String
categoryToString category =
    case category of
        Food ->
            "food"

        Housing ->
            "housing"

        PersonalCare ->
            "personal-care"

        RentAndUtilitiesAssistance ->
            "rent-and-utilities-assistance"

        MedicalCare ->
            "medical-care"

        MentalHealth ->
            "mental-health"

        AddictionServices ->
            "addiction-services"

        NursingHomesAndHospice ->
            "nursing-homes-and-hospice"

        DentalAndHearing ->
            "dental-and-hearing"

        HivPrepHepC ->
            "hiv-prep-hepc"

        Transportation ->
            "transportation"

        Internet ->
            "internet"

        Phones ->
            "phones"

        LegalAid ->
            "legal-aid"

        DomesticViolence ->
            "domestic-violence"

        SexualAssault ->
            "sexual-assault"

        IDsAndSSI ->
            "ids-and-ssi"

        JobsAndJobTraining ->
            "jobs-and-job-training"

        AdultEducation ->
            "adult-education"

        TutorsAndMentoring ->
            "tutors-and-mentoring"

        Childcare ->
            "childcare"

        ParentingHelp ->
            "parenting-help"

        SeniorsAndDisabilities ->
            "seniors-and-disabilities"

        LGBTQPlus ->
            "lgbtq-plus"

        Veterans ->
            "veterans"

        ImmigrantsAndRefugees ->
            "immigrants-and-refugees"

        FormerlyIncarcerated ->
            "formerly-incarcerated"

        OnSexOffenderRegistry ->
            "on-sex-offender-registry"

        PetHelp ->
            "pet-help"

        OutsideOfDavidsonCounty ->
            "outside-of-davidson-county"

        Arts ->
            "arts"

        Advocacy ->
            "advocacy"


type alias Service =
    { id : Int
    , category : Category
    , busLine : Maybe String
    , hours : Maybe Schedule
    , name : String
    , description : String
    , requirements : Maybe String
    , applicationProcess : Maybe String
    , notes : Maybe String
    , address : Maybe String
    , organizationName : String
    }


categoryFromString : String -> Maybe Category
categoryFromString str =
    case str of
        "food" ->
            Just Food

        "housing" ->
            Just Housing

        "personal-care" ->
            Just PersonalCare

        "rent-and-utilities-assistance" ->
            Just RentAndUtilitiesAssistance

        "medical-care" ->
            Just MedicalCare

        "mental-health" ->
            Just MentalHealth

        "addiction-services" ->
            Just AddictionServices

        "nursing-homes-and-hospice" ->
            Just NursingHomesAndHospice

        "dental-and-hearing" ->
            Just DentalAndHearing

        "hiv-prep-hepc" ->
            Just HivPrepHepC

        "transportation" ->
            Just Transportation

        "internet" ->
            Just Internet

        "phones" ->
            Just Phones

        "legal-aid" ->
            Just LegalAid

        "domestic-violence" ->
            Just DomesticViolence

        "sexual-assault" ->
            Just SexualAssault

        "ids-and-ssi" ->
            Just IDsAndSSI

        "jobs-and-job-training" ->
            Just JobsAndJobTraining

        "adult-education" ->
            Just AdultEducation

        "tutors-and-mentoring" ->
            Just TutorsAndMentoring

        "childcare" ->
            Just Childcare

        "parenting-help" ->
            Just ParentingHelp

        "seniors-and-disabilities" ->
            Just SeniorsAndDisabilities

        "lgbtq-plus" ->
            Just LGBTQPlus

        "veterans" ->
            Just Veterans

        "immigrants-and-refugees" ->
            Just ImmigrantsAndRefugees

        "formerly-incarcerated" ->
            Just FormerlyIncarcerated

        "on-sex-offender-registry" ->
            Just OnSexOffenderRegistry

        "pet-help" ->
            Just PetHelp

        "outside-of-davidson-county" ->
            Just OutsideOfDavidsonCounty

        "arts" ->
            Just Arts

        "advocacy" ->
            Just Advocacy

        _ ->
            Nothing


categoryDecoder : Decoder Category
categoryDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                Decode.succeed <|
                    case str of
                        "Advocacy" ->
                            Advocacy

                        "Arts" ->
                            Arts

                        -- need to create a new category
                        "Clothing, Day Shelters, and Showers - Clothing" ->
                            PersonalCare

                        "Clothing, Day Shelters, and Showers- Clothing and Hygiene" ->
                            PersonalCare

                        "HiSET Classes" ->
                            AdultEducation

                        "Financial Education" ->
                            AdultEducation

                        "Tutoring And Career Programs" ->
                            JobsAndJobTraining

                        "Food - Emergency Food Boxes" ->
                            Food

                        "Food- Free groceries" ->
                            Food

                        "Food- Food box" ->
                            Food

                        "Food - Wic (women, Infants And Children) Program" ->
                            Food

                        _ ->
                            Housing
            )


decoder : Decoder Service
decoder =
    decode Service
        |> custom (Decode.index 0 Decode.int)
        |> custom (Decode.index 1 categoryDecoder)
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> custom
            (Decode.index 2
                (Decode.string
                    |> Decode.andThen (\str -> Decode.succeed <| String.join " " <| List.take 4 <| String.words str)
                )
            )
        |> custom (Decode.index 2 Decode.string)
        |> custom (Decode.oneOf [ Decode.index 4 (Decode.nullable Decode.string), Decode.succeed Nothing ])
        |> custom (Decode.oneOf [ Decode.index 5 (Decode.nullable Decode.string), Decode.succeed Nothing ])
        |> custom (Decode.oneOf [ Decode.index 6 (Decode.nullable Decode.string), Decode.succeed Nothing ])
        |> hardcoded Nothing
        |> custom (Decode.index 3 string)


photo : Service -> Element msg
photo _ =
    el
        [ padding 10
        ]
        (Element.html <| FontAwesome.icon FontAwesome.infoCircle)


briefDescription : Service -> String
briefDescription service =
    String.join " " <| List.take 10 <| String.words service.description


briefDescriptionColumn : Service -> Element msg
briefDescriptionColumn service =
    textColumn [ width (fill |> maximum 250) ]
        [ paragraph [ Font.size 14 ]
            [ text service.organizationName
            ]
        , paragraph [ Font.size 12 ]
            [ text (briefDescription service) ]
        ]


distancePin : Float -> Element msg
distancePin distance =
    link []
        { url = ""
        , label =
            column []
                [ Element.el [] <|
                    Element.html <|
                        FontAwesome.iconWithOptions FontAwesome.locationArrow FontAwesome.Solid [ FontAwesome.Size FontAwesome.Large ] []
                , text (String.fromFloat distance)
                ]
        }


itemLink : Service -> Element msg -> Element msg
itemLink service children =
    link [ width fill ]
        { url = "/services/detail/" ++ String.fromInt service.id
        , label = children
        }


listItem : Float -> Service -> Element msg
listItem distance service =
    itemLink service
        (row
            [ spacing 10
            , padding 10
            , height (px 100)
            , width (fill |> minimum 330 |> maximum 1000)
            , Border.width 1
            ]
            [ photo service
            , briefDescriptionColumn service
            , distancePin distance
            ]
        )


largeListItem : Float -> Service -> Element msg
largeListItem distance service =
    itemLink service
        (row
            [ spaceEvenly
            , padding 10
            , height (px 100)
            , width fill
            , Border.width 1
            ]
            [ photo service
            , paragraph [ Font.center, padding 10 ] [ text service.organizationName ]
            , paragraph [ padding 10 ] [ text (briefDescription service) ]
            , distancePin distance
            ]
        )
