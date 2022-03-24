module Organization exposing (Organization, decoder, sheetId)

import OptimizedDecoder as Decode exposing (Decoder, int, nullable, string)
import OptimizedDecoder.Pipeline exposing (custom, decode)
import Schedule exposing (Schedule)


sheetId =
    "Organizations"


type alias Organization =
    { id : Int
    , name : String
    , busLine : Maybe String
    , schedule : Maybe Schedule
    , address : Maybe String
    , website : Maybe String
    , phone : Maybe String
    }


decoder : Decoder Organization
decoder =
    decode Organization
        |> custom (Decode.index 0 int)
        |> custom (Decode.index 1 string)
        |> custom (Decode.index 2 (nullable string))
        |> custom (Decode.index 3 (nullable Schedule.decoder))
        |> custom (Decode.index 4 (nullable string))
        |> custom (Decode.index 5 (nullable string))
        |> custom (Decode.index 6 (nullable string))
