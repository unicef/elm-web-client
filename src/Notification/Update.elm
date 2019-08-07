module Notification.Update exposing (update)

import Main.Context exposing (Context)
import Material
import Notification.Command
    exposing
        ( loadNotificationCmd
        , markAllAsReadCmd
        , markAsReadCmd
        )
import Notification.Model exposing (Model)
import Notification.Msg exposing (Msg(..))


update : Context -> Msg -> Model -> ( Model, Cmd Msg )
update ctx msg model =
    case msg of
        MarkAsRead notiId ->
            model ! [ markAsReadCmd ctx notiId ]

        MarkAllAsRead ->
            model ! [ markAllAsReadCmd ctx ]

        OnMarkAllAsReadResponse resp ->
            case resp of
                Ok _ ->
                    model ! [ loadNotificationCmd ctx 1 ]

                Err _ ->
                    model ! [ loadNotificationCmd ctx 1 ]

        OnMarkAsReadResponse resp ->
            case resp of
                Ok _ ->
                    model ! [ loadNotificationCmd ctx 1 ]

                Err _ ->
                    model ! [ loadNotificationCmd ctx 1 ]

        OnLoadNotificationResponse resp ->
            case resp of
                Ok entries ->
                    { model | entries = entries, error = Nothing } ! []

                Err _ ->
                    { model | error = Just "Error loading assets" } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model
