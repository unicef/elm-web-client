module Timeline.View exposing (render)

import Common.Colors as Colors
import Common.Styles
    exposing
        ( background
        , color
        , margin
        , marginBottom
        , marginTop
        , padding
        , paddingLeft
        , paddingTop
        , textCenter
        , textLeft
        , toMdlCss
        )
import Common.Typo as Typo
import Dict exposing (Dict)
import Gallery
import Gallery.Image as Image
import Html exposing (..)
import Html.Attributes
    exposing
        ( class
        , height
        , href
        , property
        , src
        , style
        , title
        , width
        )
import Html.Events exposing (onClick)
import Json.Encode
import Main.Context exposing (Context)
import Main.Routing exposing (assetPath, exploreInitiativesPath, profilePath)
import Material.Button as Button
import Material.Icon as Icon
import Material.Options as Options exposing (css)
import Timeline.Model
    exposing
        ( Emoji
        , Model
        , PostReaction
        , TimelineEntry
        , TimelineFilter(..)
        , TimelineType(..)
        )
import Timeline.Msg exposing (Msg(..))


render : Context -> Model -> Html Msg
render ctx model =
    div
        []
        [ case model.data of
            Nothing ->
                div [] [ text "..." ]

            Just data ->
                case List.length data.entries < 1 of
                    True ->
                        div []
                            [ case model.timelineType of
                                HomepageTimeline ->
                                    div [ paddingTop 30, paddingLeft 30 ]
                                        [ text "There are no posts to show in your stream. Follow "
                                        , a [ href exploreInitiativesPath ]
                                            [ text "initiatives" ]
                                        , text " to stay tuned."
                                        ]

                                AssetTimeline _ ->
                                    div []
                                        [ text "No one has contributed to this initiative. Be the first by posting in the form above."
                                        ]

                                UserTimeline userId ->
                                    let
                                        loggedInUserID =
                                            case ctx.user of
                                                Just user ->
                                                    user.id

                                                Nothing ->
                                                    0
                                    in
                                    case loggedInUserID == userId of
                                        True ->
                                            div []
                                                [ text "You have no posts yet. Visit "
                                                , a [ href exploreInitiativesPath ]
                                                    [ text "initiatives" ]
                                                , text " to contribute."
                                                ]

                                        False ->
                                            span [] []
                            ]

                    False ->
                        div []
                            [ div [ entriesListStyle ] <|
                                List.map (renderEntry ctx model) data.entries
                            , case data.hasMore of
                                True ->
                                    renderLoadMore ctx model

                                False ->
                                    span [] []
                            ]
        ]


renderLoadMore : Context -> Model -> Html Msg
renderLoadMore ctx model =
    div [ loadMoreButoonStyle ]
        [ Button.render Mdl
            [ 1 ]
            model.mdl
            [ Button.raised
            , Button.ripple
            , Button.colored
            , Options.onClick LoadMore
            ]
            [ text "load more ..."
            ]
        ]


renderEntry : Context -> Model -> TimelineEntry -> Html Msg
renderEntry ctx model entry =
    let
        profileImageUrl =
            case entry.userProfileImageURL == "" of
                True ->
                    "img/default-user-icon.jpg"

                False ->
                    entry.userProfileImageURL

        showVerifyBtn =
            case ctx.user of
                Just user ->
                    case user.id == entry.oracleId of
                        True ->
                            entry.status == 0

                        False ->
                            False

                Nothing ->
                    False
    in
    div [ entryStyle ]
        [ div
            [ style
                [ ( "display", "flex" )
                ]
            ]
            [ div
                [ style
                    [ ( "width", "41px" )
                    , ( "height", "41px" )
                    , ( "padding", "12px" )
                    , ( "border", "1px solid " ++ Colors.caption )
                    , ( "background-image", "url(" ++ profileImageUrl ++ ")" )
                    , ( "background-size", "cover" )
                    , ( "border-radius", "50%" )
                    ]
                ]
                []
            , div [ paddingLeft 10, paddingTop 5 ]
                [ a [ href <| profilePath entry.userId ]
                    [ text <| entry.userName
                    ]
                , case model.timelineType of
                    AssetTimeline _ ->
                        span [] []

                    _ ->
                        span []
                            [ text " posted in "
                            , a [ href (assetPath entry.assetId) ]
                                [ text " "
                                , text entry.assetName
                                ]
                            ]
                , div [] [ text entry.createdAtHuman ]
                ]
            ]
        , div
            [ style [ ( "padding", "5px 0" ) ] ]
            [ text entry.text ]
        , case entry.ytVideoId == "" of
            True ->
                span [] []

            False ->
                iframe
                    [ width 560
                    , height 315
                    , src <| "https://www.youtube.com/embed/" ++ entry.ytVideoId
                    , property "frameborder" (Json.Encode.string "0")
                    , property "allowfullscreen" (Json.Encode.string "true")
                    ]
                    []
        , case List.length entry.images > 0 of
            False ->
                span [] []

            True ->
                case List.head entry.images of
                    Just imageUrl ->
                        div
                            [ style
                                [ ( "height", "400px" )
                                , ( "width", "100%" )
                                , ( "background", "url(" ++ imageUrl ++ ") no-repeat center /cover" )
                                ]
                            ]
                            []

                    Nothing ->
                        span [] []

        -- div [ galleryContainerStyle ]
        --     [ case Dict.get entry.blockId model.gallery of
        --         Just g ->
        --             Html.map (GalleryMsg entry.blockId) <|
        --                 Gallery.view imageConfig
        --                     g
        --                     [ Gallery.Arrows ]
        --                     (imageSlides entry.images)
        --         Nothing ->
        --             span [] []
        --     ]
        , div [ toggleFavoriteStyle, onClick (ToggleFavorite entry.blockId) ]
            [ case entry.didUserLike of
                True ->
                    Icon.view "favorite"
                        [ Icon.size24
                        , toMdlCss <| color "red"
                        ]

                False ->
                    Icon.view "favorite_border"
                        [ Icon.size24
                        ]
            , span [] [ text <| toString entry.favoritesCount ]
            ]

        -- , renderMultiReaction ctx model entry
        , case entry.status == 0 of
            True ->
                div [ verifiedStatusStyle (entry.status == 1) ]
                    [ text "Pending post"
                    ]

            False ->
                span [] []
        , case showVerifyBtn of
            True ->
                div [ marginTop 10 ]
                    [ button
                        [ onClick (VerifyBlock True entry.blockId)
                        , buttonStyle
                        ]
                        [ text "Accept post"
                        ]
                    , text " "
                    , button
                        [ onClick (VerifyBlock False entry.blockId)
                        , buttonStyle
                        , style
                            [ ( "background", "#ddd" )
                            , ( "color", "black" )
                            ]
                        ]
                        [ text "Drop"
                        ]
                    ]

            False ->
                span [] []
        , case entry.ethereumTransactionAddress == "" of
            True ->
                span [] []

            False ->
                div [ txLinkStyle ]
                    [ a
                        [ href <|
                            "https://rinkeby.etherscan.io/tx/"
                                ++ entry.ethereumTransactionAddress
                        , Html.Attributes.target "_blank"
                        ]
                        [ img [ txIconStyle, src "static/images/ethereum.png" ] [] ]
                    ]
        ]


renderMultiReaction ctx model entry =
    div []
        [ div []
            [ div [] <| List.map (renderPostedEmoji ctx model entry) entry.reactions
            ]
        , div []
            [ case model.emojis of
                Just emojis ->
                    div
                        [ style
                            [ ( "position", "relative" )
                            , ( "margin-top", "10px" )
                            ]
                        ]
                        [ button
                            [ onClick (ToggleEmojiKeyboard (Just entry))
                            , buttonStyle
                            ]
                            [ text "React"
                            ]
                        , case model.entryEmojiKeyboard of
                            Just reactiveEntry ->
                                case entry.blockId == reactiveEntry.blockId of
                                    True ->
                                        div
                                            [ style
                                                [ ( "position", "absolute" )
                                                , ( "top", "0" )
                                                , ( "max-width", "274px" )
                                                , ( "background", "white" )
                                                , ( "z-index", "2" )
                                                , ( "border", "1px solid #ddd" )
                                                , ( "padding", "10px" )
                                                , ( "box-shadow", "0px 0px 13px 0px rgba(0,0,0,0.24)" )
                                                ]
                                            ]
                                            [ div [] [ text "Choose your reaction" ]
                                            , div
                                                [ marginTop 10
                                                , marginBottom 10
                                                ]
                                              <|
                                                List.map (renderEmoji ctx model entry) emojis.entries
                                            , button
                                                [ onClick (ToggleEmojiKeyboard Nothing)
                                                , buttonStyle
                                                ]
                                                [ text "Close"
                                                ]
                                            ]

                                    False ->
                                        span [] []

                            Nothing ->
                                span [] []
                        ]

                Nothing ->
                    span [] [ text "loading emojis" ]
            ]
        ]


renderPostedEmoji : Context -> Model -> TimelineEntry -> PostReaction -> Html Msg
renderPostedEmoji ctx model entry emoji =
    let
        numberOfUsers =
            List.length emoji.users

        userId =
            case ctx.user of
                Just user ->
                    user.id

                Nothing ->
                    0

        didUserReact =
            List.member userId emoji.users
    in
    div
        [ style
            [ ( "display", "inline-block" )
            , ( "padding", "3px" )
            , ( "border", "1px solid #ddd" )
            , ( "margin-top", "2px" )
            , ( "margin-right", "2px" )
            , ( "border-radius", "2px" )
            , ( "cursor", "pointer" )
            ]
        , title "Click to remove"
        ]
        [ img
            [ postedEmojiStyle
            , src <| "slack-emojis/" ++ emoji.logo
            ]
            []
        , text " "
        , text <| toString numberOfUsers
        ]


postedEmojiStyle : Attribute a
postedEmojiStyle =
    style
        [ ( "width", "30px" )
        , ( "height", "30px" )
        ]


renderEmoji : Context -> Model -> TimelineEntry -> Emoji -> Html Msg
renderEmoji ctx model entry emoji =
    img
        [ onClick (SubmitReaction entry.blockId emoji.id)
        , emojiStyle
        , src <| "slack-emojis/" ++ emoji.logo
        ]
        []


emojiStyle : Attribute a
emojiStyle =
    style
        [ ( "width", "48px" )
        , ( "height", "48px" )
        , ( "padding", "5px" )
        , ( "margin-right", "5px" )
        , ( "border-radius", "2px" )
        , ( "border", "1px solid #ddd" )
        , ( "cursor", "pointer" )
        ]


txLinkStyle : Attribute a
txLinkStyle =
    style
        [ ( "display", "inline-block" )
        , ( "float", "right" )
        , ( "padding", "15px 5px" )
        ]


txIconStyle : Attribute a
txIconStyle =
    style
        [ ( "display", "inline-block" )
        , ( "width", "30px" )
        , ( "hight", "30px" )
        ]


entriesListStyle : Attribute a
entriesListStyle =
    style [ ( "text-align", "left" ) ]


entryStyle : Attribute a
entryStyle =
    style
        [ ( "position", "relative" )
        , ( "padding-bottom", "40px" )
        ]


galleryContainerStyle : Attribute a
galleryContainerStyle =
    style
        []


loadMoreButoonStyle : Attribute a
loadMoreButoonStyle =
    style [ ( "text-align", "center" ) ]


toggleFavoriteStyle : Attribute a
toggleFavoriteStyle =
    style
        [ ( "padding", "0" )
        , ( "display", "inline-block" )
        , ( "cursor", "pointer" )
        ]


verifiedStatusStyle : Bool -> Attribute a
verifiedStatusStyle isVerified =
    style
        [ ( "background", "white" )
        ]


imageConfig : Gallery.Config
imageConfig =
    Gallery.config
        { id = "image-gallery"
        , transition = 500
        , width = Gallery.pct 100
        , height = Gallery.px 400
        }


imageSlides : List String -> List ( String, Html msg )
imageSlides images =
    List.map (\x -> ( x, Image.slide x Image.Cover )) images


buttonStyle : Attribute a
buttonStyle =
    style
        [ ( "text-align", "center" )
        , ( "background", Colors.secondary )
        , ( "font-size", Typo.s2 )
        , ( "padding", "10px" )
        , ( "border-radius", "2px" )
        , ( "border", "0" )
        , ( "color", "white" )
        ]
