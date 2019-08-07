module Timeline.Command exposing
    ( commands
    , loadTimelineCmd
    , submitReactionCmd
    , toggleFavoriteCmd
    , verifyBlockCmd
    )

import Common.Api exposing (get, postWithCsrf)
import Common.Json exposing (emptyResponseDecoder)
import Json.Decode.Pipeline as JP
import Json.Encode as JE
import Main.Context exposing (Context)
import Main.Routing exposing (Route(..))
import Timeline.Model exposing (TimelineType(..), emojisDecoder, timelineEntriesDecoder)
import Timeline.Msg exposing (Msg(..))


commands : Context -> TimelineType -> Cmd Msg
commands ctx timelineType =
    case ctx.route of
        HomepageRoute ->
            Cmd.batch
                [ loadTimelineCmd ctx 1 timelineType
                , loadEmojisCmd ctx
                ]

        AssetRoute assetId ->
            Cmd.batch
                [ loadTimelineCmd ctx 1 timelineType
                , loadEmojisCmd ctx
                ]

        ProfileRoute userId ->
            Cmd.batch
                [ loadTimelineCmd ctx 1 timelineType
                , loadEmojisCmd ctx
                ]

        _ ->
            Cmd.none


toggleFavoriteCmd : Context -> Int -> Cmd Msg
toggleFavoriteCmd ctx blockId =
    postWithCsrf ctx
        OnToggleFavoriteResponse
        ("/v2/asset-block/" ++ toString blockId ++ "/toggle-favorite")
        (JE.object [])
        (JP.decode {})


submitReactionCmd : Context -> Int -> Int -> Cmd Msg
submitReactionCmd ctx blockId emojiId =
    postWithCsrf ctx
        OnSubmitReactionResponse
        "/user/submit-emoji"
        (encodeReactionSubmition blockId emojiId)
        (JP.decode {})


encodeReactionSubmition : Int -> Int -> JE.Value
encodeReactionSubmition blockId emojiId =
    JE.object
        [ ( "blockId", JE.int blockId )
        , ( "emojiId", JE.int emojiId )
        ]


loadTimelineCmd : Context -> Int -> TimelineType -> Cmd Msg
loadTimelineCmd ctx page timelineType =
    let
        apiPath =
            case timelineType of
                HomepageTimeline ->
                    "/v2/timeline"

                UserTimeline userId ->
                    "/v2/timeline/user/" ++ toString userId

                AssetTimeline assetId ->
                    "/v2/timeline/asset/" ++ toString assetId
    in
    get ctx
        OnLoadTimelineResponse
        apiPath
        [ ( "page", toString page ) ]
        timelineEntriesDecoder


loadEmojisCmd : Context -> Cmd Msg
loadEmojisCmd ctx =
    get ctx
        OnLoadEmojisResponse
        "/emojis"
        []
        emojisDecoder


verifyBlockCmd : Context -> Bool -> Int -> Cmd Msg
verifyBlockCmd ctx isAccepted blockId =
    postWithCsrf ctx
        VerifyBlockResponse
        ("/v2/asset-block/" ++ toString blockId ++ "/verify")
        (JE.object
            [ ( "isAccepted", JE.bool isAccepted )
            ]
        )
        emptyResponseDecoder
