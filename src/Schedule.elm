module Schedule exposing (Schedule)

import Time exposing (Posix)


type alias Schedule =
    { holidays : List String
    , intervals : List ( Int, Int )
    , lastConfirmed : Posix
    }
