module Service exposing (Service, Tag(..), listItem)

import Element exposing (column, el, fill, height, link, maximum, padding, px, row, spaceEvenly, spacing, text, width)
import Element.Border as Border
import FontAwesome


type Tag
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


type alias Service =
    { id : Int
    , name : String
    , description : String
    , categories : List Tag
    }


photo service =
    el [] (text "blank image")


briefDescription service =
    column []
        [ text service.name
        , text service.description
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
        { url = "/service?id=" ++ String.fromInt service.id
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
