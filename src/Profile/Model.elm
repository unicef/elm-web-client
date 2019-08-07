module Profile.Model exposing (Asset, Model, Profile, UserAssets, init, profileDecoder, userAssetsDecoder)

import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JP
import Material
import Profile.Ports exposing (ImagePortData)
import Profile.Types exposing (ViewTab(..))
import Timeline.Model exposing (TimelineType(..))


type alias Profile =
    { id : Int
    , username : String
    , profileImageUrl : String
    , isOwnder : Bool
    , createdAtHuman : String
    }


type alias Asset =
    { id : Int
    , name : String
    , symbol : String
    , balance : String
    }


type alias UserAssets =
    { entries : List Asset
    }


type alias Model =
    { mdl : Material.Model
    , activeViewTab : ViewTab
    , data : Maybe Profile
    , imgInput : Maybe ImagePortData
    , isUploadingImage : Bool
    , uploadImageError : Maybe Http.Error
    , error : Maybe Http.Error
    , timeline : Timeline.Model.Model
    , userAssets : Maybe UserAssets
    , isLoadingMore : Bool
    , showTransferTokens : Bool
    , selectedToken : Maybe Asset
    , amount : String
    , isTransferring : Bool
    , transferError : Maybe Http.Error
    , showProfileMenu : Bool
    }


init : Model
init =
    { mdl = Material.model
    , activeViewTab = TimelineTab
    , data = Nothing
    , imgInput = Nothing
    , isUploadingImage = False
    , uploadImageError = Nothing
    , error = Nothing
    , timeline = Timeline.Model.init (UserTimeline 0)
    , userAssets = Nothing
    , isLoadingMore = False
    , showTransferTokens = False
    , selectedToken = Nothing
    , amount = ""
    , isTransferring = False
    , transferError = Nothing
    , showProfileMenu = False
    }


profileDecoder : JD.Decoder Profile
profileDecoder =
    JP.decode Profile
        |> JP.required "ID" JD.int
        |> JP.required "UserName" JD.string
        |> JP.required "ProfileImageURL" JD.string
        |> JP.required "IsOwner" JD.bool
        |> JP.required "CreatedAtHuman" JD.string


userAssetsDecoder : JD.Decoder UserAssets
userAssetsDecoder =
    JP.decode UserAssets
        |> JP.required "Balances" (JD.list userAssetDecoder)


userAssetDecoder : JD.Decoder Asset
userAssetDecoder =
    JP.decode Asset
        |> JP.required "AssetID" JD.int
        |> JP.required "Name" JD.string
        |> JP.required "Symbol" JD.string
        |> JP.required "Balance" JD.string
