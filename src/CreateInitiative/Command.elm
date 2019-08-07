module CreateInitiative.Command exposing (createInitiativeCmd, loadGitRepoCmd)

import Common.Api exposing (postWithCsrf)
import Common.Json exposing (emptyResponseDecoder)
import CreateInitiative.Model exposing (Model)
import CreateInitiative.Msg exposing (Msg(..))
import Http
import HttpBuilder exposing (..)
import Json.Decode as Decode
import Json.Decode.Pipeline as JP
import Json.Encode as JE
import Main.Context exposing (Context)
import Model.Asset exposing (assetDecoder)


createInitiativeCmd : Context -> Model -> Cmd Msg
createInitiativeCmd ctx model =
    postWithCsrf ctx
        OnCreateInitiativeSuccess
        "/v2/assets"
        (encodeCreateInitiative model)
        assetDecoder


encodeCreateInitiative : Model -> JE.Value
encodeCreateInitiative model =
    JE.object
        [ ( "name", JE.string model.name )
        , ( "symbol", JE.string model.symbol )
        , ( "purpose", JE.string model.purpose )
        ]


loadGitRepoCmd : Context -> String -> Cmd Msg
loadGitRepoCmd ctx url =
    postWithCsrf ctx
        OnGitRepoResponse
        "/load-repo-details"
        (JE.object [ ( "url", JE.string url ) ])
        emptyResponseDecoder
