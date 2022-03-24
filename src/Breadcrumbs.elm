module Breadcrumbs exposing (UrlPath, view)

import Element exposing (Element, el, link, paragraph, row, spacing, text)
import FontAwesome
import Path exposing (Path)


type alias UrlPath =
    { path : Path
    , query : Maybe String
    , fragment : Maybe String
    }


view : String -> List UrlPath -> Element msg
view label history =
    case List.head <| List.drop 1 history of
        Just lastUrl ->
            link []
                { url = Path.toAbsolute lastUrl.path
                , label =
                    row [ spacing 10 ]
                        [ el [] <| Element.html <| FontAwesome.icon FontAwesome.arrowLeft
                        , paragraph [] [ text label ]
                        ]
                }

        Nothing ->
            Element.none
