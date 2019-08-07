module Main.User exposing (User, noUserYet, userDecoder)

import Json.Decode as JD
import Json.Decode.Pipeline as JP


type alias User =
    { id : Int
    , email : String
    , username : String
    , profileImageUrl : String
    , ethereumAddress : String
    }


noUserYet : User
noUserYet =
    { id = 0
    , email = ""
    , username = ""
    , profileImageUrl = ""
    , ethereumAddress = ""
    }


userDecoder : JD.Decoder User
userDecoder =
    JP.decode User
        |> JP.required "id" JD.int
        |> JP.required "email" JD.string
        |> JP.required "name" JD.string
        |> JP.required "profileImageURL" JD.string
        |> JP.required "ethereumAddress" JD.string
