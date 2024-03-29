module ExploreInitiatives.Msg exposing (..)

import Material
import Http
import Model.Asset exposing (Asset)


type Msg
    = Mdl (Material.Msg Msg)
    | OnLoadAssetsResponse (Result Http.Error (List Asset))
    | OnLoadFavoritesResponse (Result Http.Error (List Asset))
    | OnToggleFavoriteResponse (Result Http.Error {})
    | ToggleFavorite Int
    | OnSwitchCategory String
