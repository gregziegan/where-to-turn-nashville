module Service exposing (Category(..), Service, categories, categoryFromString, categoryToString, decoder, listItem, sheetId)

import Element exposing (column, el, fill, height, link, maximum, minimum, padding, paragraph, px, row, spaceEvenly, spacing, text, textColumn, width)
import Element.Border as Border
import Element.Font as Font
import FontAwesome
import OptimizedDecoder as Decode exposing (Decoder, int, nullable, string)
import OptimizedDecoder.Pipeline exposing (custom, decode, required)
import Organization exposing (Organization)
import Schedule exposing (Schedule)


sheetId =
    "Services"


type Category
    = Shelter
    | Food
    | Healthcare
    | ShowersAndRestrooms
    | Childcare
    | DomesticViolence
    | LegalAid
    | FinancialAid
    | JobsAndEducation
    | LgbtqPlus
    | RentersAssistance
    | Internet


categories =
    [ Shelter
    , Food
    , Healthcare
    , ShowersAndRestrooms
    , Childcare
    , DomesticViolence
    , LegalAid
    , FinancialAid
    , JobsAndEducation
    , LgbtqPlus
    , RentersAssistance
    , Internet
    ]


categoryToString : Category -> String
categoryToString category =
    case category of
        Shelter ->
            "shelter"

        Food ->
            "food"

        Healthcare ->
            "healthcare"

        ShowersAndRestrooms ->
            "showers-and-restrooms"

        Childcare ->
            "childcare"

        DomesticViolence ->
            "domestic-violence"

        LegalAid ->
            "legal-aid"

        FinancialAid ->
            "financial-aid"

        JobsAndEducation ->
            "jobs-and-education"

        LgbtqPlus ->
            "lgbtq-plus"

        RentersAssistance ->
            "renters-assistance"

        Internet ->
            "internet"


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
        "shelter" ->
            Just Shelter

        "food" ->
            Just Food

        "healthcare" ->
            Just Healthcare

        "showers-and-restrooms" ->
            Just ShowersAndRestrooms

        "childcare" ->
            Just Childcare

        "domestic-violence" ->
            Just DomesticViolence

        "legal-aid" ->
            Just LegalAid

        "financial-aid" ->
            Just FinancialAid

        "jobs-and-education" ->
            Just JobsAndEducation

        "lgbtq-plus" ->
            Just LgbtqPlus

        "renters-assistance" ->
            Just RentersAssistance

        "internet" ->
            Just Internet

        _ ->
            Nothing


categoryDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                Decode.succeed <|
                    case str of
                        "Advocacy" ->
                            LegalAid

                        "Arts" ->
                            LgbtqPlus

                        -- need to create a new category
                        "Clothing, Day Shelters, and Showers - Clothing" ->
                            ShowersAndRestrooms

                        "Clothing, Day Shelters, and Showers- Clothing and Hygiene" ->
                            ShowersAndRestrooms

                        "HiSET Classes" ->
                            JobsAndEducation

                        "Financial Education" ->
                            JobsAndEducation

                        "Tutoring And Career Programs" ->
                            JobsAndEducation

                        "Food - Emergency Food Boxes" ->
                            Food

                        "Food- Free groceries" ->
                            Food

                        "Food- Food box" ->
                            Food

                        "Food - Wic (women, Infants And Children) Program" ->
                            Food

                        _ ->
                            Shelter
            )


decoder : Decoder Service
decoder =
    decode Service
        |> custom (Decode.index 0 Decode.int)
        |> custom (Decode.index 1 categoryDecoder)
        |> custom (Decode.index 2 (nullable string))
        |> custom (Decode.index 3 (nullable Schedule.decoder))
        |> custom
            (Decode.index 5
                (Decode.string
                    |> Decode.andThen (\str -> Decode.succeed <| String.join " " <| List.take 4 <| String.words str)
                )
            )
        |> custom (Decode.index 5 Decode.string)
        |> custom (Decode.oneOf [ Decode.index 6 (Decode.nullable Decode.string), Decode.succeed Nothing ])
        |> custom (Decode.oneOf [ Decode.index 7 (Decode.nullable Decode.string), Decode.succeed Nothing ])
        |> custom (Decode.oneOf [ Decode.index 8 (Decode.nullable Decode.string), Decode.succeed Nothing ])
        |> custom (Decode.oneOf [ Decode.index 9 (Decode.nullable Decode.string), Decode.succeed Nothing ])
        |> custom (Decode.index 2 string)


photo service =
    el [] (Element.html <| FontAwesome.icon FontAwesome.infoCircle)


briefDescription service =
    textColumn [ width (fill |> maximum 250) ]
        [ paragraph [ Font.size 14 ]
            [ text service.organizationName
            ]
        , paragraph [ Font.size 12 ]
            [ text <| String.join " " <| List.take 10 <| String.words service.description ]
        ]


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


listItem distance service =
    link []
        { url = "/services/detail/" ++ String.fromInt service.id
        , label =
            row
                [ spacing 10
                , padding 10
                , height (px 100)
                , width (fill |> minimum 355 |> maximum 1000)
                , Border.width 1
                ]
                [ photo service
                , briefDescription service
                , distancePin distance
                ]
        }
