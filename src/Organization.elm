module Organization exposing (Organization, decoder, sheetId, sheetRange)

import OptimizedDecoder as Decode exposing (Decoder, int, string)
import OptimizedDecoder.Pipeline exposing (custom, decode)
import Phone
import Regex exposing (Regex)
import String.Extra as String
import Util exposing (cleanNullableString)


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
    , hours : Maybe String
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


keepValidPhone : String -> Maybe String
keepValidPhone phone =
    if Phone.valid phone then
        Just phone

    else
        Nothing


normalizePhone : Maybe String -> Maybe String
normalizePhone maybePhone =
    maybePhone
        |> Maybe.andThen (String.nonEmpty << Regex.replace nonDigitRegex (\_ -> ""))
        |> Maybe.andThen keepValidPhone


decoder : Decoder Organization
decoder =
    decode Organization
        |> custom (Decode.index 0 int)
        |> custom (Decode.index 1 string)
        |> custom (Decode.index 2 cleanNullableString)
        |> custom (Decode.index 3 cleanNullableString)
        |> custom (Decode.index 4 cleanNullableString)
        |> custom (Decode.index 9 (cleanNullableString |> Decode.map normalizeSite))
        |> custom (Decode.index 10 (cleanNullableString |> Decode.map normalizePhone))
        |> custom (Decode.index 11 cleanNullableString)
