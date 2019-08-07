module CreateInitiative.Msg exposing (Msg(..))

import CreateInitiative.Types exposing (..)
import Http
import Material
import Model.Asset exposing (Asset)


type Msg
    = Mdl (Material.Msg Msg)
    | PostAsset
    | OnCreateInitiativeSuccess (Result Http.Error Asset)
    | SetName String
    | SetSymbol String
    | SetDescription String
    | SetActiveView ActiveView
    | SetCap String
    | SetGitLink String
    | LoadGitRepo String
    | OnGitRepoResponse (Result Http.Error {})
    | Back
    | ToggleCapped
    | ToggleGitProject
