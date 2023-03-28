module Link exposing (call, directions, menu, resource, website)

import Button
import Element exposing (Element, el, fill, link, maximum, newTabLink, padding, paragraph, row, spacing, text, width)
import Element.Font as Font
import FontAwesome
import Phone
import Service


menu : String -> String -> Element msg
menu label path =
    link [ width fill, Font.bold ]
        { url = path
        , label = text label
        }


resource : Service.Category -> Element msg
resource category =
    let
        branding =
            Service.branding category

        path =
            Service.categoryToString category
    in
    link
        [ width fill
        ]
        { url = "/services/" ++ path
        , label = paragraph [ width (fill |> maximum 280) ] [ text branding.title ]
        }


website : String -> Element msg
website url =
    newTabLink []
        { url = url
        , label =
            Button.transparent
                { onPress = Nothing
                , text = String.replace "https://" "" <| String.replace "https://www." "" url
                }
                |> Button.fullWidth
                |> Button.withIcon FontAwesome.externalLinkAlt
                |> Button.render
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
