module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Service
import Test exposing (..)


suite : Test
suite =
    test "converts to valid URL path" <|
        \() -> Expect.equal (Service.categoryToString Service.Shelter) "shelter"
