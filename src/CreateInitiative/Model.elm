module CreateInitiative.Model exposing (Model, init)

import Common.Json exposing (decodeAt)
import Common.Log exposing (log)
import CreateInitiative.Msg exposing (Msg(..))
import CreateInitiative.Types exposing (..)
import Debug
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JP
import Material


type alias Model =
    { mdl : Material.Model
    , step : ActiveView
    , name : String
    , symbol : String
    , purpose : String
    , capped : Bool
    , cap : String
    , isGitProject : Bool
    , gitLink : String
    , isCreatingAsset : Bool
    , createInitiativeError : Maybe Http.Error
    , createdAssetId : Int
    , createdAssetName : String
    , createdAssetSymbol : String
    }


init : Model
init =
    { mdl = Material.model
    , step = ProjectDetails
    , name = ""
    , symbol = ""
    , purpose = ""
    , capped = False
    , cap = ""
    , isGitProject = False
    , gitLink = ""
    , isCreatingAsset = False
    , createInitiativeError = Nothing
    , createdAssetId = 0
    , createdAssetName = ""
    , createdAssetSymbol = ""
    }
