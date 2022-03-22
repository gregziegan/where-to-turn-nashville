module Organization exposing (Organization)

import Schedule exposing (Schedule)


type alias Organization =
    { id : Int
    , name : String
    , busLine : Maybe String
    , schedule : Maybe Schedule
    , address : Maybe String
    , website : Maybe String
    , phone : String
    }
