module CreateInitiative.Update exposing (update)

import CreateInitiative.Command exposing (createInitiativeCmd, loadGitRepoCmd)
import CreateInitiative.Model exposing (Model)
import CreateInitiative.Msg exposing (Msg(..))
import CreateInitiative.Types exposing (..)
import Debug
import List.Extra
import Main.Context exposing (Context)
import Material
import Navigation exposing (back, newUrl)


update : Context -> Msg -> Model -> ( Model, Cmd Msg )
update ctx msg model =
    case msg of
        SetActiveView view ->
            { model | step = view } ! []

        PostAsset ->
            { model
                | isCreatingAsset = True
                , createInitiativeError = Nothing
            }
                ! [ createInitiativeCmd ctx model ]

        OnCreateInitiativeSuccess res ->
            case res of
                Ok asset ->
                    { model
                        | isCreatingAsset = False
                        , createInitiativeError = Nothing
                        , step = SuccessView
                        , createdAssetName = asset.name
                        , createdAssetSymbol = asset.symbol
                        , createdAssetId = asset.id
                    }
                        ! [ newUrl <| "#asset/" ++ toString asset.id ]

                Err error ->
                    { model
                        | isCreatingAsset = False
                        , createInitiativeError = Just error
                    }
                        ! []

        SetName value ->
            { model | name = value } ! []

        SetSymbol value ->
            { model | symbol = value } ! []

        SetDescription value ->
            { model | purpose = value } ! []

        SetCap value ->
            { model | cap = value } ! []

        ToggleCapped ->
            { model | capped = not model.capped } ! []

        ToggleGitProject ->
            { model | isGitProject = not model.isGitProject } ! []

        SetGitLink value ->
            { model | gitLink = value } ! []

        LoadGitRepo url ->
            model ! [ loadGitRepoCmd ctx url ]

        OnGitRepoResponse res ->
            model ! []

        Back ->
            model ! [ back 1 ]

        Mdl msg_ ->
            Material.update Mdl msg_ model
