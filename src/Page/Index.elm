module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (alignRight, centerX, column, el, fill, height, maximum, padding, paragraph, px, row, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FontAwesome
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Service exposing (Category(..))
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "where-to-turn-nashville"
        , image =
            { url = Pages.Url.external "https://where-to-turn-nashville.netlify.app"
            , alt = "Where to turn in Nashville logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "A handbook for our neighbors in need."
        , locale = Nothing
        , title = "Where to turn in Nashville" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    ()


viewFilterLink filter =
    let
        ( icon, title ) =
            filterDetails filter
    in
    Element.link []
        { url = "/services/" ++ Service.categoryToString filter
        , label =
            Input.button
                [ width (px 170)
                , height (px 100)
                , Border.width 1
                , spacing 5
                , padding 10
                ]
                { onPress = Nothing
                , label =
                    row [ width fill, centerX, spacing 10 ]
                        [ Element.el [] <|
                            Element.html <|
                                FontAwesome.iconWithOptions icon FontAwesome.Solid [ FontAwesome.Size (FontAwesome.Mult 2) ] []
                        , paragraph [ Font.size 14, Font.alignRight ] [ text title ]
                        ]
                }
        }


filterDetails filter =
    case filter of
        Shelter ->
            ( FontAwesome.bed, "Shelter" )

        Food ->
            ( FontAwesome.utensils, "Food" )

        Healthcare ->
            ( FontAwesome.heartbeat, "Healthcare" )

        ShowersAndRestrooms ->
            ( FontAwesome.shower, "Showers and restrooms" )

        Childcare ->
            ( FontAwesome.child, "Childcare" )

        DomesticViolence ->
            ( FontAwesome.exclamationTriangle, "Domestic violence" )

        LegalAid ->
            ( FontAwesome.balanceScale, "Legal aid" )

        FinancialAid ->
            ( FontAwesome.creditCard, "Financial aid" )

        JobsAndEducation ->
            ( FontAwesome.briefcase, "Jobs and education" )

        LgbtqPlus ->
            ( FontAwesome.flag, "LGBTQ+" )

        RentersAssistance ->
            ( FontAwesome.user, "Renters' assistance" )

        Internet ->
            ( FontAwesome.wifi, "Internet" )


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Where to turn in Nashville"
    , body =
        [ column
            [ centerX
            , width (fill |> maximum 1200)
            , padding 10
            , spacing 10
            ]
            [ paragraph [ centerX, Font.center ] [ text "Find help in Nashville" ]
            , wrappedRow [ spacing 5 ] (List.map viewFilterLink Service.categories)
            ]
        ]
    }
