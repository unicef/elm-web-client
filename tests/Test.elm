module Main exposing (..)

import ElmTest as ElmTest exposing (Test, suite, test, assertEqual)


tests : Test
tests =
    suite "Tests"
        [ test "first test" <|
            assertEqual "test" "test"
        ]


main : Program Never
main =
    ElmTest.runSuite tests
