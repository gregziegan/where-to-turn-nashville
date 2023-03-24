module Util exposing (renderIf)

import Element exposing (Element)


renderIf : Bool -> Element msg -> Element msg
renderIf cond elem =
    if cond then
        elem

    else
        Element.none
