module Schedule exposing (Schedule, decoder, toString)

import OptimizedDecoder as Decode exposing (Decoder)
import Time exposing (Posix)


type alias Schedule =
    { holidays : List String
    , intervals : List ( Int, Int )
    , lastConfirmed : Maybe Posix
    }


toString : Schedule -> String
toString schedule =
    case List.head schedule.intervals of
        Just ( _, _ ) ->
            "M 9-5"

        Nothing ->
            "Closed"


decoder : Decoder Schedule
decoder =
    Decode.map3 Schedule
        (Decode.succeed [])
        (Decode.succeed [])
        (Decode.succeed Nothing)
