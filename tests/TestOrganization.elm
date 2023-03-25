module TestOrganization exposing (suite)

import Expect
import OptimizedDecoder exposing (decodeString)
import Organization exposing (Organization)
import Schedule exposing (Schedule)
import Test exposing (Test, describe, test)


organizationJson : String
organizationJson =
    """
    [
      3,
      "Adventist Community Services",
      "#56 Stop: Gallatin Pike & Maple St ",
      "Monday - Thursday 10 a.m.- 12:30 p.m.",
      "403 Gallatin Pike S",
      "",
      "Nashville",
      37115,
      "TN",
      "www.acsgreaternashville.com",
      "615-860-6001",
      "Assistance is provided on a first come first serve basis",
      44642.573518518519
    ]
"""


organization : Organization
organization =
    { id = 3
    , name = "Adventist Community Services"
    , busLine = Just "#56 Stop: Gallatin Pike & Maple St "
    , schedule = Just (Schedule [] [] Nothing)
    , address = Just "403 Gallatin Pike S"
    , website = Just "https://www.acsgreaternashville.com"
    , phone = Just "6158606001"
    , notes = Just "Assistance is provided on a first come first serve basis"
    }


suite : Test
suite =
    describe "The Organization modle"
        [ describe "decoder"
            [ test "decodes a full JSON array" <|
                \() -> Expect.equal (Ok organization) (decodeString Organization.decoder organizationJson)
            ]
        ]
