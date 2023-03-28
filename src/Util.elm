module Util exposing (cleanNullableString, cleanString, renderIf, renderWhenPresent)

import Element exposing (Element)
import OptimizedDecoder as Decode exposing (Decoder, string)
import String.Extra as String


renderIf : Bool -> Element msg -> Element msg
renderIf cond elem =
    if cond then
        elem

    else
        Element.none


renderWhenPresent : (a -> Element msg) -> Maybe a -> Element msg
renderWhenPresent render maybe =
    case maybe of
        Just something ->
            render something

        Nothing ->
            Element.none


cleanString : Decoder String
cleanString =
    string
        |> Decode.map String.clean


cleanNullableString : Decoder (Maybe String)
cleanNullableString =
    string
        |> Decode.map (String.nonEmpty << String.clean)
