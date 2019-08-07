module Notification.Command exposing
    ( commands
    , loadNotificationCmd
    , markAllAsReadCmd
    , markAsReadCmd
    )

import Common.Api exposing (get, postWithCsrf)
import Common.Json exposing (emptyResponseDecoder)
import Json.Decode as JD
import Json.Decode.Pipeline as JP
import Json.Encode as JE
import Main.Context exposing (Context)
import Main.Routing exposing (Route(..))
import Notification.Model exposing (Message)
import Notification.Msg exposing (Msg(..))


commands : Context -> Cmd Msg
commands ctx =
    case ctx.route of
        NotificationRoute ->
            Cmd.batch
                [ loadNotificationCmd ctx 1
                ]

        _ ->
            Cmd.batch
                [ loadNotificationCmd ctx 1
                ]


markAsReadCmd ctx notiId =
    postWithCsrf ctx
        OnMarkAsReadResponse
        "/notification/mark-as-read"
        (JE.object
            [ ( "id", JE.int notiId )
            ]
        )
        (JP.decode {})


markAllAsReadCmd ctx =
    postWithCsrf ctx
        OnMarkAllAsReadResponse
        "/notification/mark-all-as-read"
        (JE.object
            []
        )
        (JP.decode {})


loadNotificationCmd : Context -> Int -> Cmd Msg
loadNotificationCmd ctx page =
    get ctx
        OnLoadNotificationResponse
        "/notifications"
        [ ( "page", toString page ) ]
        notificationMsgsDecoder


notificationMsgDecoder : JD.Decoder Message
notificationMsgDecoder =
    JP.decode Message
        |> JP.required "ID" JD.int
        |> JP.required "SenderID" JD.int
        |> JP.required "SenderName" JD.string
        |> JP.required "ReceiverID" JD.int
        |> JP.required "ReceiverName" JD.string
        |> JP.required "TopicID" JD.int
        |> JP.required "TopicName" JD.string
        |> JP.required "TopicSymbol" JD.string
        |> JP.required "Type" JD.int
        |> JP.required "IsRead" JD.bool
        |> JP.required "CreatedAt" JD.string
        |> JP.required "CreatedAtHuman" JD.string


notificationMsgsDecoder : JD.Decoder (List Message)
notificationMsgsDecoder =
    JD.list notificationMsgDecoder
