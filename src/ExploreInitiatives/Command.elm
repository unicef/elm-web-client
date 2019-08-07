module ExploreInitiatives.Command exposing (commands, loadAssetsCmd, loadFavoritesCmd, toggleFavoriteCmd)

import Common.Api exposing (get, postWithCsrf)
import ExploreInitiatives.Msg exposing (Msg(..))
import Json.Decode.Pipeline as JP
import Json.Encode as JE
import Main.Context exposing (Context)
import Main.Routing exposing (Route(..))
import Model.Asset exposing (assetListDecoder)


commands : Context -> Cmd Msg
commands ctx =
    case ctx.route of
        ExploreInitiativesRoute ->
            Cmd.batch
                [ loadAssetsCmd ctx 1
                , loadFavoritesCmd ctx
                ]

        _ ->
            Cmd.none


loadAssetsCmd : Context -> Int -> Cmd Msg
loadAssetsCmd ctx page =
    get ctx
        OnLoadAssetsResponse
        "/v2/assets"
        [ ( "page", toString page ) ]
        assetListDecoder


loadFavoritesCmd : Context -> Cmd Msg
loadFavoritesCmd ctx =
    get ctx
        OnLoadFavoritesResponse
        "/v2/assets-favorites"
        []
        assetListDecoder


toggleFavoriteCmd : Context -> Int -> Cmd Msg
toggleFavoriteCmd ctx assetId =
    postWithCsrf ctx
        OnToggleFavoriteResponse
        ("/v2/assets/" ++ toString assetId ++ "/toggle-favorite")
        (JE.object
            [ ( "assetId", JE.int assetId )
            ]
        )
        (JP.decode {})
