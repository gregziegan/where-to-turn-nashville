module Link exposing (call, directions, menu, website)

import Button
import Element exposing (Element, el, fill, link, newTabLink, padding, row, spacing, text, width)
import Element.Font as Font
import FontAwesome
import Phone


menu : String -> String -> Element msg
menu label path =
    link [ width fill, Font.bold ]
        { url = path
        , label = text label
        }


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


directions : String -> Element msg
directions address =
    newTabLink []
        { url = "https://www.google.com/maps/dir/?api=1&destination=" ++ address
        , label =
            Button.transparent
                { onPress = Nothing
                , text = "Directions"
                }
                |> Button.fullWidth
                |> Button.withIcon FontAwesome.mapMarker
                |> Button.render
        }


call : String -> Element msg
call phone =
    let
        formattedPhone : String
        formattedPhone =
            Phone.format phone
    in
    link []
        { url = "tel:+" ++ phone
        , label =
            Button.transparent
                { onPress = Nothing
                , text = "Call " ++ formattedPhone
                }
                |> Button.fullWidth
                |> Button.withIcon FontAwesome.phone
                |> Button.withIconOptions [ FontAwesome.Transform [ FontAwesome.FlipHorizontal ] ]
                |> Button.render
        }
