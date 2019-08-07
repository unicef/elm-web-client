module Model.Balance exposing (Balance, balanceDecoder, balancesDecoder)

import Json.Decode as JD
import Json.Decode.Pipeline as JP


type alias Balance =
    { assetId : Int
    , symbol : String
    , name : String
    , balance : String
    , reserved : String
    }


balanceDecoder : JD.Decoder Balance
balanceDecoder =
    JP.decode Balance
        |> JP.required "AssetID" JD.int
        |> JP.required "Symbol" JD.string
        |> JP.required "Name" JD.string
        |> JP.required "Balance" JD.string
        |> JP.required "Reserved" JD.string


balancesDecoder : JD.Decoder (List Balance)
balancesDecoder =
    JD.list balanceDecoder
