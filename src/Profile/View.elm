module Profile.View exposing (render)

import Common.Colors as Colors
import Common.Decimal exposing (renderDecimalWithPrecision)
import Common.Error exposing (renderHttpError)
import Common.Spinner as Spinner
import Common.Styles
    exposing
        ( margin
        , marginBottom
        , marginLeft
        , marginTop
        , padding
        , paddingBottom
        , paddingLeft
        , paddingRight
        , paddingTop
        , textCenter
        , textLeft
        , toMdlCss
        )
import Common.Typo as Typo
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput, onMouseEnter, onMouseLeave)
import Identicon exposing (identicon)
import Json.Decode as JD
import Main.Context exposing (Context)
import Main.Routing exposing (assetPath, exploreInitiativesPath, notificationPath)
import Material.Button as Button
import Material.Icon as Icon
import Material.Options as Options exposing (css)
import Profile.Model exposing (Asset, Model, Profile, UserAssets)
import Profile.Msg exposing (Msg(..), idxToTab, tabToIdx)
import Profile.Types exposing (ViewTab(..))
import Timeline.View


render : Context -> Model -> Int -> Html Msg
render ctx model profileId =
    div [ margin 30 ]
        [ case model.data of
            Just profile ->
                div []
                    [ renderProfile ctx model profile
                    , case model.userAssets of
                        Nothing ->
                            span [] []

                        Just assets ->
                            div [ marginTop 30, marginLeft 85 ]
                                [ case profile.isOwnder of
                                    True ->
                                        div []
                                            [ renderUserAssets ctx model assets
                                            ]

                                    False ->
                                        span [] []
                                ]

                    -- , renderTabs ctx model profile
                    ]

            Nothing ->
                div [ textCenter ] [ Spinner.render "One moment..." ]
        ]


renderProfile : Context -> Model -> Profile -> Html Msg
renderProfile ctx model profile =
    let
        imgUrl =
            case model.imgInput of
                Just data ->
                    data.contents

                Nothing ->
                    profile.profileImageUrl
    in
    div []
        [ renderHttpError model.error

        -- , case ctx.user of
        --     Just user ->
        --         case user.id == profile.id of
        --             True ->
        --                 div
        --                     [ onClick ToggleProfileMenu
        --                     , style
        --                         [ ( "position", "fixed" )
        --                         , ( "top", "15px" )
        --                         , ( "right", "15px" )
        --                         , ( "width", "40px" )
        --                         , ( "height", "30px" )
        --                         ]
        --                     ]
        --                     [ img
        --                         [ style [ ( "width", "35px" ) ]
        --                         , src "/img/icons/dots.png"
        --                         ]
        --                         []
        --                     ]
        --             False ->
        --                 span [] []
        --     Nothing ->
        --         span [] []
        , case model.showProfileMenu of
            True ->
                div
                    [ style
                        [ ( "position", "fixed" )
                        , ( "top", "10px" )
                        , ( "right", "10px" )
                        , ( "background", "white" )
                        , ( "z-index", "3" )
                        , ( "padding", "10px" )
                        , ( "border", "1px solid #ddd" )
                        , ( "border-radius", "2px" )
                        ]
                    ]
                    [ case ctx.user of
                        Just user ->
                            case user.id == profile.id of
                                True ->
                                    let
                                        mStyle =
                                            style
                                                [ ( "margin-bottom", "10px" )
                                                ]
                                    in
                                    div []
                                        [ div []
                                            [ a [ mStyle, href notificationPath ]
                                                [ text "Notifications" ]
                                            ]
                                        , div [] [ a [ mStyle, href "/wapi/logout" ] [ text "Logout" ] ]
                                        , div [] [ a [ mStyle, onClick ToggleProfileMenu ] [ text "Dismiss" ] ]
                                        ]

                                False ->
                                    span [] []

                        Nothing ->
                            span [] []
                    ]

            False ->
                span [] []
        , div [ coverContainerStyle ]
            [ div
                [ coverProfileImageStyle imgUrl ctx.window.isMobile
                ]
                [ case ctx.user of
                    Just user ->
                        case user.id == profile.id of
                            True ->
                                renderImageSelector ctx model profile

                            False ->
                                span [] []

                    Nothing ->
                        span [] []
                ]
            , div [ marginLeft 15, paddingTop 13 ]
                [ header [] [ text profile.username ]

                -- , case ctx.user of
                --     Just user ->
                --         case user.id == profile.id of
                --             True ->
                --                 div []
                --                     [ a [ href notificationPath ]
                --                         [ text "Notifications" ]
                --                     , text " - "
                --                     , a [ href "/wapi/logout" ] [ text "Logout" ]
                --                     ]
                --             False ->
                --                 span [] []
                --     Nothing ->
                --         span [] []
                , small []
                    [ text "Member since "
                    , text profile.createdAtHuman
                    ]
                ]
            ]
        ]


renderTabs : Context -> Model -> Profile -> Html Msg
renderTabs ctx model profile =
    div []
        [ div
            [ style
                [ ( "display", "flex" )
                , ( "margin", "30px 0" )
                , ( "position", "relative" )
                , ( "border-bottom", "1px solid #979797" )
                ]
            ]
            [ case profile.isOwnder of
                True ->
                    div
                        [ tabStyle (model.activeViewTab == TimelineTab)
                        , onClick (idxToTab 0)
                        ]
                        [ text "Posts" ]

                False ->
                    span [] []
            , case profile.isOwnder of
                True ->
                    div
                        [ tabStyle (model.activeViewTab == WalletTab)
                        , onClick (idxToTab 1)
                        ]
                        [ text "Balance" ]

                False ->
                    span [] []
            , case profile.isOwnder of
                True ->
                    div
                        [ tabStyle (model.activeViewTab == TokensTab)
                        , onClick (idxToTab 2)
                        ]
                        [ text "Account" ]

                False ->
                    span [] []
            ]
        , div []
            [ case model.activeViewTab of
                TimelineTab ->
                    Html.map TimelineMsg <|
                        Timeline.View.render ctx model.timeline

                WalletTab ->
                    case model.userAssets of
                        Nothing ->
                            span [] []

                        Just assets ->
                            renderUserAssets ctx model assets

                TokensTab ->
                    let
                        ( userEmail, userEthereumAddress ) =
                            case ctx.user of
                                Just user ->
                                    ( user.email, user.ethereumAddress )

                                Nothing ->
                                    ( "", "" )
                    in
                    div []
                        [ div []
                            [ b [] [ text "Email:" ]
                            , br [] []
                            , text userEmail
                            ]
                        , div [ marginTop 15 ]
                            [ b [] [ text "Ethereum Address:" ]
                            , br [] []
                            , small [] [ text userEthereumAddress ]
                            ]
                        ]
            ]
        ]


renderUserAssets : Context -> Model -> UserAssets -> Html Msg
renderUserAssets ctx model asset =
    case List.length asset.entries < 1 of
        True ->
            div []
                [ text "Your did not earn any rewards. "
                , text "Contribute to "
                , a [ href exploreInitiativesPath ] [ text "initiatives" ]
                , text " to start receiving rewards."
                ]

        False ->
            div [] <|
                List.map renderUserAsset asset.entries


renderUserAsset : Asset -> Html Msg
renderUserAsset asset =
    a
        [ style
            [ ( "display", "flex" )
            , ( "padding-bottom", "30px" )
            ]
        , href (assetPath asset.id)
        ]
        [ div
            [ style
                [ ( "width", "20px" )
                , ( "height", "20px" )
                , ( "padding", "10px" )
                , ( "border", "1px solid #ddd" )
                ]
            ]
            [ identicon "20px" asset.name ]
        , div
            [ style
                [ ( "padding", "5px 10px" )
                , ( "flex-grow", "1" )
                , ( "text-align", "left" )
                ]
            ]
            [ header [ paddingBottom 5 ]
                [ renderDecimalWithPrecision asset.balance 2
                , text " "
                , text (String.toUpper asset.symbol)
                ]
            ]
        ]


renderImageSelector : Context -> Model -> Profile -> Html Msg
renderImageSelector ctx model profile =
    div [ imgSelectorContainer ]
        [ span []
            [ input
                [ imgInputStyle
                , type_ "file"
                , id "profile-img-input"
                , on "change"
                    (JD.succeed ImageSelected)
                ]
                []
            , div [ imgIconContainerStyle ]
                [ case model.isUploadingImage of
                    True ->
                        span [] [ text "uploading" ]

                    False ->
                        span [] []
                ]
            ]
        ]


imgSelectorContainer : Attribute a
imgSelectorContainer =
    style
        []


imgInputStyle : Attribute a
imgInputStyle =
    style
        [ ( "opacity", "0" )
        , ( "position", "absolute" )
        , ( "top", "0" )
        , ( "left", "0" )
        , ( "right", "0" )
        , ( "width", "120px" )
        , ( "bottom", "0" )
        , ( "z-index", "1" )
        ]


imgIconContainerStyle : Attribute a
imgIconContainerStyle =
    style
        [ ( "color", "white" )
        , ( "margin", "40px 20px 20px" )
        ]


coverContainerStyle : Attribute a
coverContainerStyle =
    style
        [ ( "width", "100%" )
        , ( "display", "flex" )
        ]


coverProfileImageStyle : String -> Bool -> Attribute a
coverProfileImageStyle data isMobile =
    let
        url =
            case data == "" of
                True ->
                    "img/default-user-icon.jpg"

                False ->
                    data

        top =
            case isMobile of
                True ->
                    "50px"

                False ->
                    "110px"
    in
    style
        [ ( "width", "68px" )
        , ( "height", "68px" )
        , ( "border", "1px solid #ddd" )
        , ( "background", "url(" ++ url ++ ") no-repeat center /cover" )
        , ( "z-index", "11" )
        , ( "border-radius", "50%" )
        , ( "position", "relative" )
        ]


buttonStyle : Attribute a
buttonStyle =
    style
        [ ( "text-align", "center" )
        , ( "line-height", "normal" )
        , ( "text-decoration", "none" )
        , ( "color", "inherit" )
        , ( "display", "inline-block" )
        , ( "box-shadow", "none" )
        , ( "float", "right" )
        , ( "border-radius", "8px" )
        , ( "background", "white" )
        , ( "color", "black" )
        , ( "margin", "5px" )
        ]


tabStyle : Bool -> Attribute a
tabStyle isActive =
    let
        ( c, fontWeight ) =
            case isActive of
                True ->
                    ( Colors.secondary, "bold" )

                False ->
                    ( "inherit", "normal" )
    in
    style
        [ ( "padding", "10px" )
        , ( "font-weight", fontWeight )
        , ( "text-align", "center" )
        , ( "color", c )
        , ( "cursor", "pointer" )
        , ( "border-top-left-radius", "2px" )
        , ( "border-top-right-radius", "2px" )
        , ( "flex-grow", "1" )
        ]
