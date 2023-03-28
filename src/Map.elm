module Map exposing (view)

import Element exposing (Element, el)
import Html exposing (iframe)
import Html.Attributes as Attrs


view : String -> Element msg
view mapUrl =
    el [] <|
        Element.html <|
            iframe
                [ Attrs.width 600
                , Attrs.height 450
                , Attrs.style "border" "0"
                , Attrs.attribute "loading" "lazy"
                , Attrs.attribute "allowfullscreen" ""
                , Attrs.attribute
                    "referrerpolicy"
                    "no-referrer-when-downgrade"
                , Attrs.src mapUrl
                ]
                []
