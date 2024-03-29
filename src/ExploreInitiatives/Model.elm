module ExploreInitiatives.Model exposing (..)

import Common.Json exposing (decodeAt)
import Common.Log exposing (log)
import ExploreInitiatives.Msg exposing (Msg(..))
import Material
import Model.Asset exposing (Asset)


type alias Model =
    { mdl : Material.Model
    , assetCategories : List String
    , activeCategory: String
    , assets : List Asset
    , favorites : List Asset
    , error : Maybe String
    }


init : Model
init =
    { mdl = Material.model
    , assetCategories = [ "Trends",  "Sport", "Entertainment", "Tourism", "Business", "Lifestyle", "Nature"  ]
    , activeCategory = "Trends"
    , assets = []
    , favorites = []
    , error = Nothing
    }
