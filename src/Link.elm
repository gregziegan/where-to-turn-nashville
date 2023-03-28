module Link exposing (website)

import Element exposing (Element, el, newTabLink, padding, row, spacing, text)
import FontAwesome


website : String -> Element msg
website url =
    newTabLink []
        { url = url
        , label =
            row [ spacing 10, padding 10 ]
                [ text <| String.replace "https://" "" <| String.replace "https://www." "" url
                , el [] <| Element.html <| FontAwesome.icon FontAwesome.externalLinkAlt
                ]
        }
