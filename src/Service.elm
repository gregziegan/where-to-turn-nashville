module Service exposing (Category(..), Service, categories, categoryFromString, categoryToString, decoder, listItem)

import Element exposing (column, el, fill, height, link, maximum, padding, px, row, spaceEvenly, spacing, text, width)
import Element.Border as Border
import FontAwesome
import OptimizedDecoder as Decode exposing (Decoder, int, string)
import OptimizedDecoder.Pipeline exposing (required)
import Organization exposing (Organization)


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
    , name : String
    , description : String
    , requirements : Maybe String
    , applicationProcess : Maybe String
    , notes : Maybe String
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
    Decode.map7 Service
        (Decode.index 0 Decode.int)
        (Decode.index 1 categoryDecoder)
        (Decode.index 5
            (Decode.string
                |> Decode.andThen (\str -> Decode.succeed <| String.join " " <| List.take 4 <| String.words str)
            )
        )
        (Decode.index 5 Decode.string)
        (Decode.oneOf [ Decode.index 6 (Decode.nullable Decode.string), Decode.succeed Nothing ])
        (Decode.oneOf [ Decode.index 7 (Decode.nullable Decode.string), Decode.succeed Nothing ])
        (Decode.oneOf [ Decode.index 8 (Decode.nullable Decode.string), Decode.succeed Nothing ])


photo service =
    el [] (text "blank image")


briefDescription service =
    column []
        [ text service.name
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
                [ spaceEvenly
                , padding 10
                , height (px 100)
                , width (fill |> maximum 375)
                , Border.width 1
                ]
                [ photo service
                , briefDescription service
                , distancePin distance
                ]
        }
