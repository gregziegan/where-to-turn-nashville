module Page.Service exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (centerX, column, fill, maximum, padding, paragraph, row, spacing, text, width)
import Element.Font as Font
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
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
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Where to turn in Nashville"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "Where to turn in Nashville logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Where to turn in Nashville"
        , locale = Nothing
        , title = "Where to turn in Nashville" -- metadata.title -- TODO
        }
        |> Seo.website


serviceLogo =
    text "blank image"


serviceDescription =
    text "long description"


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Where to turn in Nashville | Service"
    , body =
        [ column
            [ centerX
            , width (fill |> maximum 1200)
            , padding 10
            , spacing 10
            ]
            [ serviceLogo
            , serviceDescription
            ]
        ]
    }
