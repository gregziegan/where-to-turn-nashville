module Page.About exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (column, fill, paragraph, text, width)
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)
import Element exposing (maximum)
import Element exposing (centerY)


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
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Where to turn in Nashville | About"
    , body =
        [ column [ centerY, width (fill |> maximum 800) ]
            [ paragraph [] [ text "The \"Where to Turn in Nashville\" resource guide is a publication of Open Table Nashville in coordination with Middle Tennessee nonprofits, hospitals, churches, and public agencies.  To ensure information is as accurate as possible, they make updates and re-print the resource guide booklet each January, and make updates online on an ongoing basis." ]
            ]
        ]
    }
