module Main.ViewNavigation exposing (render)

import Common.Colors as Colors
import Common.Styles exposing (paddingTop)
import Html exposing (..)
import Html.Attributes exposing (attribute, href, src, style)
import Html.Events exposing (onClick)
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Main.Routing
    exposing
        ( Route(..)
        , createInitiativePath
        , exploreInitiativesPath
        , homepagePath
        , notificationPath
        , profilePath
        )
import Material.Badge as Badge
import Material.Icon as Icon


render : Model -> Html Msg
render model =
    let
        userId =
            case model.context.user of
                Just user ->
                    user.id

                Nothing ->
                    0

        userName =
            case model.context.user of
                Just user ->
                    user.username

                Nothing ->
                    ""
    in
    div [ bhStyle model.context.window.isMobile ]
        [ a
            [ href homepagePath
            , bhNavItemStyle
            , activeRouteStyle (model.context.route == HomepageRoute)
            , style [ ( "width", "45%" ) ]
            ]
            [ text "Activity"
            ]
        , a
            [ href exploreInitiativesPath
            , bhNavItemStyle
            , activeRouteStyle (model.context.route == ExploreInitiativesRoute)
            , style [ ( "width", "45%" ) ]
            ]
            [ text "Initiatives"
            ]
        , a
            [ onClick ToggleProfileMenu
            , bhNavItemStyle
            , style
                [ ( "width", "10%" )
                ]
            ]
            [ img
                [ style [ ( "width", "10px" ) ]
                , src "/img/icons/dots.png"
                ]
                []
            ]

        -- , a
        --     [ href (profilePath userId)
        --     , bhNavItemStyle
        --     , activeRouteStyle (model.context.route == ProfileRoute userId)
        --     , style [ ( "width", "33%" ), ( "position", "relative" ) ]
        --     ]
        --     [ text "Rewards"
        --     , small
        --         [ style
        --             [ ( "position", "absolute" )
        --             , ( "display", "inline-block" )
        --             , ( "bottom", "33px" )
        --             , ( "right", "0px" )
        --             , ( "left", "0px" )
        --             , ( "height", "10px" )
        --             ]
        --         ]
        --         [ text " 0BTC" ]
        -- , let
        --     unreadEntries =
        --         List.filter (\v -> v.isRead == False) model.notification.entries
        --     unreadCounter =
        --         List.length unreadEntries
        --     hasNotifications =
        --         unreadCounter > 0
        --   in
        --   case hasNotifications of
        --     True ->
        --         span
        --             [ style
        --                 [ ( "position", "absolute" )
        --                 , ( "top", "5px" )
        --                 , ( "bottom", "5px" )
        --                 , ( "width", "20px" )
        --                 , ( "height", "20px" )
        --                 , ( "background", Colors.secondary )
        --                 , ( "border-radius", "10px" )
        --                 , ( "line-height", "1" )
        --                 , ( "color", "white" )
        --                 , ( "padding", "3px" )
        --                 , ( "display", "inline-block" )
        --                 , ( "margin-left", "4px" )
        --                 ]
        --             ]
        --             [ text <| toString unreadCounter ]
        --     False ->
        --         span [] []
        -- ]
        ]


imgIconStyle : Attribute a
imgIconStyle =
    style
        [ ( "width", "30px" )
        , ( "height", "30px" )
        ]


activeRouteStyle : Bool -> Attribute a
activeRouteStyle isActive =
    case isActive of
        True ->
            style
                [ ( "font-weight", "bold" )
                , ( "color", Colors.secondary )
                ]

        False ->
            style
                [ ( "font-weight", "normal" ) ]


bhStyle : Bool -> Attribute a
bhStyle isMobile =
    let
        ( w, l, r, t, d, m ) =
            case isMobile of
                True ->
                    ( "100%", "0", "0", "inherit", "0", "0" )

                False ->
                    ( "600px", "inherit", "inherit", "0", "inherit", "0 auto" )

        whichBorder =
            case isMobile of
                True ->
                    "top"

                False ->
                    "bottom"
    in
    style
        [ ( "position", "fixed" )
        , ( "bottom", "0" )
        , ( "left", l )
        , ( "right", r )
        , ( "top", t )
        , ( "bottom", d )
        , ( "width", w )
        , ( "maring", m )
        , ( "height", "60px" )
        , ( "min-width", "320px" )
        , ( "z-index", "100" )
        , ( "border-" ++ whichBorder, "1px solid #979797" )
        , ( "background", "white" )
        ]


bhNavItemStyle : Attribute a
bhNavItemStyle =
    style
        [ ( "display", "inline-block" )
        , ( "text-align", "center" )
        , ( "line-height", "64px" )
        , ( "text-decoration", "none" )
        , ( "overflow", "hidden" )
        , ( "color", "#737373" )
        , ( "cursor", "pointer" )
        , ( "height", "59px" )
        , ( "padding", "0 3px" )
        , ( "text-overflow", "ellipsis" )
        ]
