module Service exposing (Branding, Category(..), Service, branding, care, categories, categoryFromString, categoryToString, connectivity, decoder, familyAndYouth, forGroups, help, largeListItem, listItem, other, sheetId, sheetRange, urgentNeeds, viewIcon, work)

import Element exposing (Element, centerX, fill, height, link, maximum, minimum, padding, paragraph, px, row, spaceEvenly, spacing, text, textColumn, width)
import Element.Border as Border
import Element.Font as Font
import FontAwesome exposing (Icon, Option(..), Transform(..))
import OptimizedDecoder as Decode exposing (Decoder, string)
import OptimizedDecoder.Pipeline exposing (custom, decode, hardcoded)
import String
import String.Extra as String
import Util exposing (cleanNullableString, cleanString)


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
    , hours : Maybe String
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
                let
                    normalizedCategory : String
                    normalizedCategory =
                        str
                            |> String.replace "-" ""
                            |> String.toLower
                            |> String.clean
                in
                Decode.succeed <|
                    case normalizedCategory of
                        "advocacy" ->
                            Advocacy

                        "arts" ->
                            Arts

                        -- need to create a new category
                        "clothing, day shelters, and showers clothing" ->
                            PersonalCare

                        "clothing, day shelters, and showers showers" ->
                            PersonalCare

                        "clothing, day shelters, and showers clothing and hygiene" ->
                            PersonalCare

                        "hiset classes" ->
                            AdultEducation

                        "financial education" ->
                            AdultEducation

                        "tutoring and career programs" ->
                            JobsAndJobTraining

                        "food children's programs" ->
                            Food

                        "food emergency food boxes" ->
                            Food

                        "food community garden" ->
                            Food

                        "food food pantry" ->
                            Food

                        "food free groceries" ->
                            Food

                        "food food box" ->
                            Food

                        "food snap" ->
                            Food

                        "food wic (women, infants and children) program" ->
                            Food

                        "employment" ->
                            JobsAndJobTraining

                        "formerly incarcerated" ->
                            FormerlyIncarcerated

                        "housing domestic violence shelters" ->
                            Housing

                        "housing emergency shelters" ->
                            Housing

                        "housing rent and utilities assistance" ->
                            Housing

                        "housing transitional housing & halfway houses" ->
                            Housing

                        "section 8 vouchers" ->
                            Housing

                        "section 8 voucher properties" ->
                            Housing

                        "housing for people over 65 and on disability" ->
                            Housing

                        "housing for people under 62 who are not recieving disability and do not have a section 8 voucher" ->
                            Housing

                        "housing for people on the sex offender registry" ->
                            Housing

                        "housing agencies and resources" ->
                            Housing

                        "motels" ->
                            Housing

                        "immigrant/refugee services" ->
                            ImmigrantsAndRefugees

                        "immigrant/refugee services english for a fee" ->
                            ImmigrantsAndRefugees

                        "legal services" ->
                            LegalAid

                        "addiction services" ->
                            AddictionServices

                        "addiction peer support / 12 step groups" ->
                            AddictionServices

                        "addiction women's alcohol/substance abuse groups" ->
                            AddictionServices

                        "addiction recovering housing with 12-step programs" ->
                            AddictionServices

                        "addiction intensive outpatient programs" ->
                            AddictionServices

                        "addiction detox/inpatient help" ->
                            AddictionServices

                        "addiction - outpatient \"mat\" services (buprenorphine)" ->
                            AddictionServices

                        "mental health services" ->
                            MentalHealth

                        "counseling services" ->
                            MentalHealth

                        "health providers" ->
                            MedicalCare

                        "reproductive health care" ->
                            MedicalCare

                        "sexual assault care" ->
                            SexualAssault

                        "medical specialists" ->
                            MedicalCare

                        "medical respite care" ->
                            MedicalCare

                        "nursing home care" ->
                            NursingHomesAndHospice

                        "prep, hiv, hep c treatment" ->
                            HivPrepHepC

                        "transgender hormone therapy" ->
                            MedicalCare

                        "hospice care" ->
                            NursingHomesAndHospice

                        "dental care" ->
                            DentalAndHearing

                        "denture care" ->
                            DentalAndHearing

                        "hearing care" ->
                            DentalAndHearing

                        "transportation to medical appointments" ->
                            Transportation

                        "medication resources" ->
                            MedicalCare

                        "medical resources for refugees and immigrants" ->
                            MedicalCare

                        "hospitals & financial assistance" ->
                            MedicalCare

                        "pets" ->
                            PetHelp

                        "phones" ->
                            Phones

                        "social services" ->
                            MedicalCare

                        "social services disability advocacy" ->
                            SeniorsAndDisabilities

                        "social services how to apply for a tn state i.d." ->
                            IDsAndSSI

                        "social services senior services" ->
                            SeniorsAndDisabilities

                        "social services social security cards" ->
                            IDsAndSSI

                        "transportation" ->
                            Transportation

                        "veterans services" ->
                            Veterans

                        _ ->
                            if String.contains "surrounding county resources" normalizedCategory then
                                OutsideOfDavidsonCounty

                            else if String.contains "youth & family services" normalizedCategory then
                                ParentingHelp

                            else
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
        |> custom (Decode.index 2 cleanString)
        |> custom (Decode.index 4 cleanNullableString)
        |> custom (Decode.index 5 cleanNullableString)
        |> custom (Decode.index 6 cleanNullableString)
        |> hardcoded Nothing
        |> custom (Decode.index 3 string)


briefDescription : Service -> String
briefDescription service =
    let
        words : List String
        words =
            String.words service.description

        ellipses : String
        ellipses =
            if List.length words > 10 then
                "..."

            else
                ""
    in
    (words
        |> List.take 10
        |> String.join " "
    )
        ++ ellipses


briefDescriptionColumn : Service -> Element msg
briefDescriptionColumn service =
    textColumn [ width (fill |> maximum 250) ]
        [ paragraph [ Font.size 14 ]
            [ text service.organizationName
            ]
        , paragraph [ Font.size 12 ]
            [ text (briefDescription service) ]
        ]


itemLink : Service -> Element msg -> Element msg
itemLink service children =
    link [ width fill ]
        { url = "/services/detail/" ++ String.fromInt service.id
        , label = children
        }


listItem : Service -> Element msg
listItem service =
    itemLink service
        (row
            [ spacing 10
            , padding 10
            , height (px 100)
            , width (fill |> minimum 330 |> maximum 1000)
            , Border.width 1
            ]
            [ viewIcon (branding service.category)
            , briefDescriptionColumn service
            ]
        )


largeListItem : Service -> Element msg
largeListItem service =
    itemLink service
        (row
            [ spaceEvenly
            , padding 10
            , height (px 100)
            , width fill
            , Border.width 1
            ]
            [ viewIcon (branding service.category)
            , paragraph [ Font.center, padding 10 ] [ text service.organizationName ]
            , paragraph [ padding 10 ] [ text (briefDescription service) ]
            ]
        )


type alias Branding =
    { icon : Icon
    , iconOptions : List Option
    , title : String
    }


viewIcon : Branding -> Element msg
viewIcon { icon, iconOptions } =
    Element.el [ Font.center, centerX ] <|
        Element.html <|
            FontAwesome.iconWithOptions icon FontAwesome.Solid (FontAwesome.Size (FontAwesome.Mult 2) :: iconOptions) []


branding : Category -> Branding
branding filter =
    case filter of
        Food ->
            Branding FontAwesome.utensils [] "Food"

        Housing ->
            Branding FontAwesome.home [] "Housing"

        PersonalCare ->
            Branding FontAwesome.shower [] "Personal care"

        RentAndUtilitiesAssistance ->
            Branding FontAwesome.moneyCheckAlt [] "Rent and utilities assistance"

        MedicalCare ->
            Branding FontAwesome.stethoscope [] "Medical care"

        MentalHealth ->
            Branding FontAwesome.brain [] "Mental health"

        AddictionServices ->
            Branding FontAwesome.wineBottle [] "Addiction services"

        NursingHomesAndHospice ->
            Branding FontAwesome.bed [] "Nursing homes and hospice"

        DentalAndHearing ->
            Branding FontAwesome.tooth [] "Dental and hearing"

        HivPrepHepC ->
            Branding FontAwesome.ribbon [] "HIV, PrEP, and Hep C"

        Transportation ->
            Branding FontAwesome.bus [] "Transportation"

        Internet ->
            Branding FontAwesome.wifi [] "Internet"

        Phones ->
            Branding FontAwesome.mobile [] "Phones"

        LegalAid ->
            Branding FontAwesome.balanceScale [] "Legal aid"

        DomesticViolence ->
            Branding FontAwesome.fistRaised [ Transform [ Rotate 90 ] ] "Domestic violence"

        SexualAssault ->
            Branding FontAwesome.exclamationTriangle [] "Sexual assault"

        IDsAndSSI ->
            Branding FontAwesome.idCard [] "IDs and SSI"

        JobsAndJobTraining ->
            Branding FontAwesome.briefcase [] "Jobs and job training"

        AdultEducation ->
            Branding FontAwesome.graduationCap [] "Adult education"

        TutorsAndMentoring ->
            Branding FontAwesome.school [] "Tutors and mentoring"

        Childcare ->
            Branding FontAwesome.hands [] "Childcare"

        ParentingHelp ->
            Branding FontAwesome.handHoldingHeart [] "Parenting help"

        SeniorsAndDisabilities ->
            Branding FontAwesome.wheelchair [] "Seniors and people with disabilities"

        LGBTQPlus ->
            Branding FontAwesome.flag [] "LGBTQ+"

        Veterans ->
            Branding FontAwesome.medal [] "Veterans"

        ImmigrantsAndRefugees ->
            Branding FontAwesome.globeAfrica [] "Immigrants and refugees"

        FormerlyIncarcerated ->
            Branding FontAwesome.box [] "Formerly incarcerated"

        OnSexOffenderRegistry ->
            Branding FontAwesome.list [] "On sex offender registry"

        PetHelp ->
            Branding FontAwesome.dog [] "Pet help"

        OutsideOfDavidsonCounty ->
            Branding FontAwesome.mapSigns [] "Outside of Davidson Co."

        Arts ->
            Branding FontAwesome.theaterMasks [] "Arts"

        Advocacy ->
            Branding FontAwesome.handshake [] "Advocacy"
