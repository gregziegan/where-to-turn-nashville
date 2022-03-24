module Window exposing (Window, decoder)

import OptimizedDecoder as Decode exposing (Decoder, int)
import OptimizedDecoder.Pipeline exposing (required)


type alias Window =
    { width : Int
    , height : Int
    }


decoder : Decoder Window
decoder =
    Decode.succeed Window
        |> required "width" int
        |> required "height" int
