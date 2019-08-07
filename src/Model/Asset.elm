module Model.Asset exposing (Asset, assetDecoder, assetListDecoder)

import Json.Decode as JD
import Json.Decode.Pipeline as JP


type alias Asset =
    { id : Int
    , name : String
    , symbol : String
    , creatorId : Int
    , creatorName : String
    , description : String
    , totalSupply : Int
    , minersCount : Int
    , favoritesCount : Int
    , didUserLike : Bool
    }


assetDecoder : JD.Decoder Asset
assetDecoder =
    JP.decode Asset
        |> JP.required "ID" JD.int
        |> JP.required "Name" JD.string
        |> JP.required "Symbol" JD.string
        |> JP.required "CreatorID" JD.int
        |> JP.required "CreatorName" JD.string
        |> JP.required "Description" JD.string
        |> JP.required "Supply" JD.int
        |> JP.required "MinersCounter" JD.int
        |> JP.required "FavoritesCounter" JD.int
        |> JP.required "DidUserLike" JD.bool


assetListDecoder : JD.Decoder (List Asset)
assetListDecoder =
    JD.list assetDecoder
