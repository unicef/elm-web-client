module Main.ViewBody exposing (ifAuth, ifNotAuth, render, renderLogin)

import Asset.View
import Common.Colors as Colors
import Common.Styles exposing (marginBottom, marginTop, textCenter)
import CreateInitiative.View
import ExploreInitiatives.View
import Homepage.Homepage
import Homepage.View
import Html exposing (..)
import Html.Attributes exposing (href, src, style)
import Html.Events exposing (onClick)
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Main.NotFound
import Main.Routing exposing (Route(..), notificationPath, profilePath)
import Notification.View
import Profile.View
import Site.Privacy as PrivacyView
import Site.TermsOfService as TermsOfServiceView
import UserLogin.ViewForgot
import UserLogin.ViewForgotResetPass
import UserLogin.ViewLogin
import UserLogin.ViewSignup


render : Model -> Html Msg
render model =
    case model.context.route of
        UserLoginRoute ->
            ifNotAuth model <| renderLogin model

        UserForgotRoute ->
            ifNotAuth model <| Html.map UserLoginMsg <| UserLogin.ViewForgot.render model.userlogin

        UserForgotResetPassRoute _ _ ->
            Html.map UserLoginMsg <| UserLogin.ViewForgotResetPass.render model.context model.userlogin

        UserSignupRoute ->
            ifNotAuth model <| Html.map UserLoginMsg <| UserLogin.ViewSignup.render model.userlogin

        HomepageRoute ->
            ifAuth model <| Html.map HomepageMsg <| Homepage.View.render model.context model.homepage

        ExploreInitiativesRoute ->
            ifAuth model <|
                Html.map ExploreInitiativesMsg <|
                    ExploreInitiatives.View.render model.context model.exploreInitiatives

        NotificationRoute ->
            ifAuth model <|
                Html.map NotificationMsg <|
                    Notification.View.render model.context model.notification

        CreateInitiativeRoute ->
            ifAuth model <|
                Html.map CreateInitiativeMsg <|
                    CreateInitiative.View.render model.context model.createInitiative

        AssetRoute assetId ->
            ifAuth model <|
                Html.map AssetMsg <|
                    Asset.View.render model.context model.asset assetId

        ProfileRoute profileId ->
            ifAuth model <|
                Html.map ProfileMsg <|
                    Profile.View.render model.context model.profile profileId

        NotFoundRoute ->
            Main.NotFound.render model

        TermsRoute ->
            TermsOfServiceView.render

        PrivacyRoute ->
            PrivacyView.render


renderLogin : Model -> Html Msg
renderLogin model =
    Html.map HomepageMsg <| Homepage.View.render model.context model.homepage


ifAuth : Model -> Html Msg -> Html Msg
ifAuth model view =
    case model.context.user of
        Just user ->
            div []
                [ case model.showUserMenu of
                    True ->
                        div
                            [ style
                                [ ( "position", "fixed" )
                                , ( "top", "0" )
                                , ( "right", "0" )
                                , ( "left", "0" )
                                , ( "bottom", "0" )
                                , ( "background", "white" )
                                , ( "z-index", "100" )
                                ]
                            ]
                            [ renderContents model view
                            ]

                    False ->
                        span [] []
                , view
                ]

        Nothing ->
            renderLogin model


renderContents model view =
    let
        mStyle =
            style
                [ ( "padding", "10px" )
                , ( "display", "block" )
                , ( "border", "1px solid #ddd" )
                , ( "color", Colors.secondary )
                , ( "font-weight", "normal" )
                , ( "margin", "30px 30px 0 30px" )
                ]

        userId =
            case model.context.user of
                Just user ->
                    user.id

                Nothing ->
                    0
    in
    div [ textCenter ]
        [ div []
            [ header [ marginTop 60 ] [ text "Prototype" ]
            ]
        , a
            [ mStyle
            , onClick ToggleProfileMenu
            , href (profilePath userId)
            ]
            [ text "Your rewards" ]
        , a
            [ mStyle
            , onClick ToggleProfileMenu
            , href "/wapi/logout"
            ]
            [ text "Logout" ]
        , a
            [ style
                [ ( "position", "fixed" )
                , ( "top", "0" )
                , ( "right", "0" )
                , ( "padding", "10px" )
                , ( "color", Colors.secondary )
                , ( "font-weight", "normal" )
                ]
            , onClick ToggleProfileMenu
            ]
            [ text "Close" ]
        ]


ifNotAuth : Model -> Html Msg -> Html Msg
ifNotAuth model view =
    case model.context.user of
        Just _ ->
            div [] []

        Nothing ->
            view
