module Notification.View exposing (render)

import Common.Styles exposing (padding, paddingLeft, paddingTop, textCenter, toMdlCss)
import Common.Typo as Typo
import Html exposing (..)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick)
import Main.Context exposing (Context)
import Main.Routing exposing (assetPath, profilePath)
import Material.Options as Options exposing (css)
import Notification.Model exposing (Model)
import Notification.Msg exposing (Msg(..))


render : Context -> Model -> Html Msg
render ctx model =
    let
        read is i =
            i.isRead == is

        unreadEntries =
            List.filter (read False) model.entries

        readEntries =
            List.filter (read True) model.entries
    in
    div []
        [ case List.length model.entries == 0 of
            True ->
                div [ padding 60 ]
                    [ text "You have no notifications"
                    ]

            False ->
                div
                    [ style
                        [ ( "padding", "30px" )
                        ]
                    ]
                    [ div []
                        [ div
                            [ style
                                [ ( "padding-bottom", "10px" )
                                ]
                            ]
                            [ header
                                [ style [ ( "display", "inline-block" ) ]
                                ]
                                [ text "New" ]
                            , case List.length unreadEntries < 1 of
                                True ->
                                    span [] []

                                False ->
                                    div []
                                        [ a [ onClick MarkAllAsRead ]
                                            [ text " mark all as read" ]
                                        ]
                            ]
                        , case List.length unreadEntries < 1 of
                            True ->
                                div []
                                    [ text "No new notifications!"
                                    ]

                            False ->
                                div [] <| List.map (renderNotification ctx model) unreadEntries
                        ]
                    , div
                        [ style
                            [ ( "margin-top", "15px" )
                            ]
                        ]
                        [ div
                            [ style
                                [ ( "padding-bottom", "10px" )
                                , ( "padding-top", "30px" )
                                ]
                            ]
                            [ header [] [ text "Earlier" ]
                            ]
                        , case List.length readEntries < 1 of
                            True ->
                                div []
                                    [ text "No earlier notifications!"
                                    ]

                            False ->
                                div [] <|
                                    List.map
                                        (renderNotification ctx model)
                                        readEntries
                        ]
                    ]
        ]


renderNotification ctx model noti =
    let
        bg =
            case noti.isRead of
                True ->
                    "inherit"

                False ->
                    "#ecf9ff"
    in
    div
        [ style
            [ ( "padding-bottom", "20px" )
            ]
        ]
        [ a [ href (profilePath noti.senderId) ] [ text noti.senderName ]
        , case noti.notificationType of
            0 ->
                text " followed your topic "

            1 ->
                text " posted in your topic "

            2 ->
                text " has accepted your post in "

            _ ->
                text ""
        , a [ href (assetPath noti.topicId), onClick (MarkAsRead noti.id) ]
            [ text noti.topicName
            ]
        , br [] []
        , text noti.createdAtHuman
        , case noti.isRead of
            True ->
                span [] []

            False ->
                span []
                    [ text " - "
                    , a
                        [ onClick (MarkAsRead noti.id)
                        ]
                        [ text " mark as read" ]
                    ]
        ]
