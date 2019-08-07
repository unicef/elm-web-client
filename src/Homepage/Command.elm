module Homepage.Command exposing (commands, loginCmd)

import Common.Api exposing (postWithCsrf)
import Homepage.Model exposing (Model)
import Homepage.Msg exposing (Msg(..))
import Json.Encode as JE
import Main.Context exposing (Context)
import Main.User exposing (User, userDecoder)
import Timeline.Command
import Timeline.Model exposing (TimelineType(..))


commands : Context -> Model -> Cmd Msg
commands ctx model =
    Cmd.map TimelineMsg <| Timeline.Command.commands ctx HomepageTimeline


loginCmd : Context -> Model -> Cmd Msg
loginCmd ctx model =
    postWithCsrf ctx
        OnLoginResponse
        "/login"
        (encodeLogin model)
        userDecoder


encodeLogin : Model -> JE.Value
encodeLogin model =
    JE.object
        [ ( "name", JE.string model.name )
        ]
