module Homepage.View exposing (render)

import Common.Colors as Colors
import Common.Styles exposing (margin, padding, textCenter)
import Homepage.Model exposing (Model)
import Homepage.Msg exposing (Msg(..))
import Homepage.NotAuth
import Html exposing (..)
import Html.Attributes exposing (style)
import Main.Context exposing (Context)
import Material.Button as Button
import Material.Icon as Icon
import Material.Options exposing (css)
import Timeline.View


render : Context -> Model -> Html Msg
render ctx model =
    case ctx.user of
        Just data ->
            div [ margin 30 ]
                [ Html.map TimelineMsg <|
                    div []
                        [ Timeline.View.render ctx model.timeline
                        ]
                ]

        Nothing ->
            Homepage.NotAuth.render ctx model
