module Page.About exposing (Data, Model, Msg, RouteParams, page)

import DataSource exposing (DataSource)
import Element exposing (centerY, column, fill, maximum, paragraph, text, width)
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
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


type alias Data =
    ()


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head _ =
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


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ _ =
    { title = "Where to turn in Nashville | About"
    , body =
        [ column [ centerY, width (fill |> maximum 800) ]
            [ paragraph [] [ text "The \"Where to Turn in Nashville\" resource guide is a publication of Open Table Nashville in coordination with Middle Tennessee nonprofits, hospitals, churches, and public agencies.  To ensure information is as accurate as possible, they make updates and re-print the resource guide booklet each January, and make updates online on an ongoing basis." ]
            ]
        ]
    }
