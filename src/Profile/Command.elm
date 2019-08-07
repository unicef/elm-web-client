module Profile.Command exposing
    ( commands
    , loadProfileCmd
    , loadUserAssets
    , transferCmd
    , uploadImageCmd
    )

import Common.Api exposing (get, postWithCsrf)
import Common.Json exposing (emptyResponseDecoder)
import Json.Encode as JE
import Main.Context exposing (Context)
import Main.Routing exposing (Route(..))
import Profile.Model exposing (profileDecoder, userAssetsDecoder)
import Profile.Msg exposing (Msg(..))


commands : Context -> Cmd Msg
commands ctx =
    case ctx.route of
        ProfileRoute userId ->
            Cmd.batch
                [ loadProfileCmd ctx userId
                , loadUserAssets ctx userId 1
                ]

        _ ->
            Cmd.none


loadProfileCmd : Context -> Int -> Cmd Msg
loadProfileCmd ctx profileId =
    get ctx
        OnProfileLoadResponse
        ("/users/" ++ toString profileId)
        []
        profileDecoder


loadUserAssets : Context -> Int -> Int -> Cmd Msg
loadUserAssets ctx userId page =
    get ctx
        OnUserAssetsLoadResponse
        "/balances"
        [ ( "page", toString page ) ]
        userAssetsDecoder


transferCmd : Context -> String -> Int -> Int -> Cmd Msg
transferCmd ctx amount toId assetId =
    postWithCsrf ctx
        OnTransferResponse
        "/transfer"
        (JE.object
            [ ( "amount", JE.string amount )
            , ( "toId", JE.int toId )
            , ( "assetId", JE.int assetId )
            ]
        )
        emptyResponseDecoder


uploadImageCmd : Context -> Int -> String -> Cmd Msg
uploadImageCmd ctx userId base64 =
    postWithCsrf ctx
        OnUploadProfileImageResponse
        "/user/profile-image"
        (encodeImage userId base64)
        emptyResponseDecoder


encodeImage : Int -> String -> JE.Value
encodeImage userId base64 =
    JE.object
        [ ( "userId", JE.int userId )
        , ( "image", JE.string base64 )
        ]
