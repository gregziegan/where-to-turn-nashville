module TestService exposing (suite)

import Expect
import OptimizedDecoder exposing (decodeString)
import Service exposing (Service)
import Test exposing (Test, describe, test)


serviceJson : String
serviceJson =
    """
    [
        4,
        "Advocacy",
        "Handles a broad range of cases to protect livelihood, legal issues, health and safety of low income families. ",
        "Legal Aid Society of Middle Tennessee",
        "Must call beforehand",
        "1-800-238-1443",
        "Services available in all language on website ",
        44642.57351851852
    ]
"""


service : Service
service =
    { id = 4
    , category = Service.Advocacy
    , busLine = Nothing
    , name = "Handles a broad range"
    , description = "Handles a broad range of cases to protect livelihood, legal issues, health and safety of low income families. "
    , requirements = Just "Must call beforehand"
    , applicationProcess = Just "1-800-238-1443"
    , hours = Nothing
    , notes = Just "Services available in all language on website "
    , address = Nothing
    , organizationName = "Legal Aid Society of Middle Tennessee"
    }


suite : Test
suite =
    describe "The Service module"
        [ describe "categoryToString"
            [ test "converts to valid URL path" <|
                \() -> Expect.equal (Service.categoryToString Service.Arts) "arts"
            ]
        , describe "decoder"
            [ test "works on a full JSON array" <|
                \() -> Expect.equal (Ok service) (decodeString Service.decoder serviceJson)
            ]
        ]
