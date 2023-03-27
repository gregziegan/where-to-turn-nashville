module Organization exposing (Organization, decoder, sheetId, sheetRange)

import OptimizedDecoder as Decode exposing (Decoder, int, nullable, string)
import OptimizedDecoder.Pipeline exposing (custom, decode)
import Regex exposing (Regex)
import Schedule exposing (Schedule)


sheetId : String
sheetId =
    "Organizations"


sheetRange : String
sheetRange =
    "A2:M"


type alias Organization =
    { id : Int
    , name : String
    , busLine : Maybe String
    , schedule : Maybe Schedule
    , address : Maybe String
    , website : Maybe String
    , phone : Maybe String
    , notes : Maybe String
    }


normalizeSite : Maybe String -> Maybe String
normalizeSite maybeSite =
    Maybe.map
        (\str ->
            if String.startsWith "http" str then
                str

            else
                "https://" ++ str
        )
        maybeSite


nonDigitRegex : Regex
nonDigitRegex =
    Maybe.withDefault Regex.never <| Regex.fromString "[^0-9]"


normalizePhone : Maybe String -> Maybe String
normalizePhone maybePhone =
    Maybe.map
        (Regex.replace nonDigitRegex (\_ -> ""))
        maybePhone


decoder : Decoder Organization
decoder =
    decode Organization
        |> custom (Decode.index 0 int)
        |> custom (Decode.index 1 string)
        |> custom (Decode.index 2 (nullable string))
        |> custom (Decode.index 3 (nullable Schedule.decoder))
        |> custom (Decode.index 4 (nullable string))
        |> custom (Decode.index 9 (nullable string |> Decode.map normalizeSite))
        |> custom (Decode.index 10 (nullable string |> Decode.map normalizePhone))
        |> custom (Decode.index 11 (nullable string))
