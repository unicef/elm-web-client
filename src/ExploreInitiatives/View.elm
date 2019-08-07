module ExploreInitiatives.View exposing (render, renderAsset)

import Common.Colors as Colors
import Common.Styles
    exposing
        ( marginBottom
        , marginTop
        , padding
        , paddingLeft
        , paddingTop
        , textCenter
        , toMdlCss
        )
import ExploreInitiatives.Model exposing (Model)
import ExploreInitiatives.Msg exposing (Msg(..))
import Html exposing (..)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick)
import Identicon exposing (identicon)
import Main.Context exposing (Context)
import Main.Routing exposing (assetPath, profilePath)
import Material.Button as Button
import Material.Icon as Icon
import Material.Options exposing (css)
import Model.Asset exposing (Asset)


render : Context -> Model -> Html Msg
render ctx model =
    div [ cardsWrapStyle ]
        [ case List.length model.assets == 0 of
            True ->
                div [ padding 60, marginTop 60 ]
                    [ text "There are no initiatives to show. Click the plus button to create a new one."
                    ]

            False ->
                div []
                    [ div [ entriesListStyle ] <|
                        List.map (renderAsset ctx model) model.assets
                    ]
        , let
            bottomTopPos =
                case ctx.window.isMobile of
                    True ->
                        ( "top", "0px" )

                    False ->
                        ( "top", "90px" )
          in
          div [ textCenter ]
            [ div
                [ style
                    [ ( "position", "fixed" )
                    , bottomTopPos
                    , ( "right", "10px" )
                    ]
                ]
                [ Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.fab
                    , Button.ripple
                    , Button.colored
                    , css "margin" "15px 0"
                    , css "background" Colors.secondary
                    , Button.link "#create-asset"
                    ]
                    [ Icon.i "add" ]
                ]
            ]
        ]


renderAsset : Context -> Model -> Asset -> Html Msg
renderAsset ctx model asset =
    div [ entryStyle ]
        [ div [ style [ ( "display", "flex" ) ] ]
            [ div
                [ style
                    [ ( "width", "40px" )
                    , ( "height", "40px" )
                    , ( "padding", "10px" )
                    , ( "border", "1px solid #ddd" )
                    ]
                ]
                [ identicon "40px" asset.name ]
            , div
                [ style
                    [ ( "padding", "15px 10px" )
                    , ( "flex-grow", "1" )
                    ]
                ]
                [ div []
                    [ a [ href (assetPath asset.id) ] [ text asset.name ] ]
                , div []
                    [ text (toString asset.totalSupply)
                    , case asset.totalSupply == 1 of
                        True ->
                            text " action"

                        False ->
                            text " actions"
                    ]
                ]
            ]
        ]


cardsWrapStyle : Attribute a
cardsWrapStyle =
    style
        []


entriesListStyle : Attribute a
entriesListStyle =
    style [ ( "text-align", "left" ) ]


entryStyle : Attribute a
entryStyle =
    style
        [ ( "margin", "30px 30px 0 30px" )
        , ( "position", "relative" )
        ]
