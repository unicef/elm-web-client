module Asset.View exposing (render)

import Asset.Model exposing (Asset, Block, Image, Miner, Model)
import Asset.Msg exposing (Msg(..))
import Common.Colors as Colors
import Common.Decimal exposing (renderDecimalWithPrecision)
import Common.Error exposing (renderHttpError)
import Common.Spinner as Spinner
import Common.Styles
    exposing
        ( background
        , margin
        , marginBottom
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
import Html.Events exposing (on, onClick, onFocus, onInput)
import Identicon exposing (identicon)
import Json.Decode as JD
import Main.Context exposing (Context)
import Main.Routing exposing (profilePath)
import Material.Icon as Icon
import Timeline.View


render : Context -> Model -> Int -> Html Msg
render ctx model assetId =
    div [ margin 30 ]
        [ case model.data of
            Just asset ->
                renderAsset ctx model asset

            Nothing ->
                div [ textCenter ] [ Spinner.render "One moment..." ]
        ]


renderAsset : Context -> Model -> Asset -> Html Msg
renderAsset ctx model asset =
    div [ assetCardStyle ctx.window.isMobile ]
        [ renderHeader ctx model asset
        , div [ paddingTop 30 ] [ renderBlocksTab ctx model asset ]

        -- , renderTabs ctx model asset
        ]


renderHeader : Context -> Model -> Asset -> Html Msg
renderHeader ctx model asset =
    div
        []
        [ div
            [ style
                [ ( "display", "flex" )
                , ( "flex-direction", "row" )
                , ( "align-items", "stretch" )
                ]
            ]
            [ div
                [ style
                    [ ( "width", "100px" )
                    , ( "height", "100px" )
                    , ( "border", "1px solid #ddd" )
                    , ( "background", "white" )
                    , ( "padding", "10px" )
                    , ( "text-align", "center" )
                    ]
                ]
                [ identicon "100px" asset.name
                ]
            , div
                [ style
                    [ ( "flex-grow", "1" )
                    , ( "margin-left", "10px" )
                    ]
                ]
                [ div
                    [ style
                        [ ( "display", "flex" )
                        ]
                    ]
                    [ div [ style [ ( "flex", "1" ) ] ]
                        [ span [ style [ ( "font-weight", "bold" ) ] ]
                            [ text (toString asset.totalSupply) ]
                        , br [] []
                        , case asset.totalSupply == 1 of
                            True ->
                                text "Post"

                            False ->
                                text "Posts"
                        ]
                    , div [ style [ ( "flex", "1" ) ] ]
                        [ span [ style [ ( "font-weight", "bold" ) ] ]
                            [ text (toString asset.favoritesCount) ]
                        , br [] []
                        , case asset.favoritesCount == 1 of
                            True ->
                                text "Follower"

                            False ->
                                text "Followers"
                        ]
                    ]
                , div []
                    [ button
                        [ onClick (ToggleFavorite asset.id)
                        , toggleFavoriteStyle asset.didUserLike
                        ]
                        [ case asset.didUserLike of
                            True ->
                                text "Unfollow"

                            False ->
                                text "Follow"
                        ]
                    ]
                , div [ marginTop 12 ]
                    [ text "Creator: "
                    , a [ href (profilePath asset.creatorId) ]
                        [ text asset.creatorName ]
                    ]
                ]
            ]
        , div
            [ marginTop 30, marginBottom 5 ]
            [ header []
                [ text asset.name
                , span
                    [ style
                        [ ( "font-weight", "normal" )
                        ]
                    ]
                    [ text <| " - " ++ asset.symbol ++ "" ]
                ]
            ]
        , div []
            [ text asset.description
            ]
        ]


toggleFavoriteStyle : Bool -> Attribute a
toggleFavoriteStyle didUserFollow =
    let
        bg =
            case didUserFollow of
                True ->
                    Colors.caption

                False ->
                    Colors.secondary
    in
    style
        [ ( "width", "90%" )
        , ( "background", bg )
        , ( "font-size", Typo.s2 )
        , ( "padding", "10px" )
        , ( "margin", "5px 0" )
        , ( "border-radius", "2px" )
        , ( "border", "0" )
        , ( "color", "white" )
        ]


renderTabs : Context -> Model -> Asset -> Html Msg
renderTabs ctx model asset =
    div []
        [ div
            [ style
                [ ( "display", "flex" )
                , ( "margin", "30px 0" )
                , ( "position", "relative" )
                ]
            ]
            [ div
                [ style
                    [ ( "height", "2px" )
                    , ( "width", "100%" )
                    , ( "background", "#ddd" )
                    , ( "position", "absolute" )
                    , ( "bottom", "0" )
                    , ( "z-index", "-1" )
                    ]
                ]
                []
            , div
                [ tabStyle (model.tab == 0)
                , onClick (SelectTab 0)
                ]
                [ text "Posts" ]

            -- , div
            --     [ tabStyle (model.tab == 1)
            --     , onClick (SelectTab 1)
            --     ]
            --     [ text "Market" ]
            ]
        , div []
            [ case model.tab of
                0 ->
                    renderBlocksTab ctx model asset

                _ ->
                    div [] [ text "" ]
            ]
        ]


tabStyle : Bool -> Attribute a
tabStyle isActive =
    let
        ( c, bg, borderBottom ) =
            case isActive of
                True ->
                    ( "white", Colors.secondary, "2px solid " ++ Colors.secondaryDark )

                False ->
                    ( "black", "none", "none" )
    in
    style
        [ ( "padding", "10px" )
        , ( "background", bg )
        , ( "border-bottom", borderBottom )
        , ( "cursor", "pointer" )
        , ( "color", c )
        , ( "border-top-left-radius", "2px" )
        , ( "border-top-right-radius", "2px" )
        ]


renderBlocksTab : Context -> Model -> Asset -> Html Msg
renderBlocksTab ctx model asset =
    div []
        [ renderBlockForm ctx model asset
        , renderBlocksList ctx model asset
        ]


renderBlocksList : Context -> Model -> Asset -> Html Msg
renderBlocksList ctx model asset =
    div [ marginTop 30 ]
        [ Html.map TimelineMsg <|
            Timeline.View.render ctx model.timeline
        ]


renderBlockForm : Context -> Model -> Asset -> Html Msg
renderBlockForm ctx model asset =
    div
        [ blockFormContainerStyle
        ]
        [ div
            []
            [ textarea
                [ textareaStyle
                , value model.blockText
                , placeholder <| "Compose new post! "
                , onInput SetBlockText
                , rows 5
                ]
                []
            , renderFormImages ctx model asset
            , renderHttpError model.submitBlockError
            , div [ cardBtnsStyle ]
                [ renderImageSelector ctx model asset
                , div [ submitBtnStyle ]
                    [ button
                        [ onClick SubmitBlock
                        , disabled model.isSubmittingBlock
                        , buttonStyle
                        ]
                        [ case model.isSubmittingBlock of
                            True ->
                                text "Moment"

                            False ->
                                text "Publish"
                        ]
                    , div
                        [ style
                            [ ( "display", "inline-block" )
                            , ( "float", "right" )
                            , ( "padding", "10px" )
                            ]
                        ]
                        [ text <| toString (String.length model.blockText) ++ "/10k" ]
                    ]
                ]
            ]
        ]


renderImageSelector : Context -> Model -> Asset -> Html Msg
renderImageSelector ctx model asset =
    case List.length model.imgs >= 1 of
        True ->
            small [ imgSelectorContainer ] [ text "Images limit reached" ]

        False ->
            div [ imgSelectorContainer ]
                [ input
                    [ imgInputStyle
                    , type_ "file"
                    , id "block-img"
                    , on "change"
                        (JD.succeed ImageSelected)
                    ]
                    []
                , div [ imgIconContainerStyle ]
                    [ Icon.view "add_a_photo" [ Icon.size24 ] ]
                ]


renderFormImages : Context -> Model -> Asset -> Html Msg
renderFormImages ctx model asset =
    div [ imgsContainerStyle ] <|
        List.indexedMap (renderImage ctx model asset) model.imgs


renderImage : Context -> Model -> Asset -> Int -> Image -> Html Msg
renderImage context model asset idx image =
    case image.contents == "" of
        True ->
            div [] []

        False ->
            div [ imgThumbnailContainerStyle ]
                [ img [ src image.contents, imgThumbnailStyle ] []
                , div [ imgDeleteStyle, onClick (DeleteImage idx) ] [ text "X" ]
                ]


assetCardStyle : Bool -> Attribute a
assetCardStyle isMobile =
    let
        minWidth =
            case isMobile of
                True ->
                    "300px"

                False ->
                    "600px"
    in
    style
        [ ( "padding-bottom", "50px" )
        , ( "max-width", "600px" )
        , ( "min-width", minWidth )
        , ( "margin", "auto" )
        ]


buttonStyle : Attribute a
buttonStyle =
    style
        [ ( "text-align", "center" )
        , ( "float", "right" )
        , ( "background", Colors.secondary )
        , ( "font-size", Typo.s2 )
        , ( "padding", "10px" )
        , ( "border-radius", "2px" )
        , ( "border", "0" )
        , ( "color", "white" )
        ]


cardBtnsStyle : Attribute a
cardBtnsStyle =
    style
        [ ( "border-top", "1px solid #dd" )
        , ( "height", "45px" )
        ]


submitBtnStyle : Attribute a
submitBtnStyle =
    style
        [ ( "text-align", "center" )
        ]


imgSelectorContainer : Attribute a
imgSelectorContainer =
    style
        [ ( "position", "relative" )
        , ( "float", "left" )
        , ( "padding", "12px 0 0 3px" )
        ]


imgIconContainerStyle : Attribute a
imgIconContainerStyle =
    style
        []


imgInputStyle : Attribute a
imgInputStyle =
    style
        [ ( "position", "absolute" )
        , ( "left", "0" )
        , ( "top", "0" )
        , ( "right", "0" )
        , ( "bottom", "0" )
        , ( "opacity", "0" )
        , ( "width", "100%" )
        , ( "z-index", "1" )
        ]


textareaStyle : Attribute a
textareaStyle =
    style
        [ ( "border", "none" )
        , ( "padding", "4px 8px" )
        , ( "width", "100%" )
        , ( "box-sizing", "border-box" )
        , ( "margin-top", "5px" )
        , ( "font-size", Typo.s2 )
        , ( "font-family", Typo.primaryFace )
        ]


blockFormContainerStyle : Attribute a
blockFormContainerStyle =
    style
        [ ( "border", "1px solid #ddd" )
        , ( "padding", "0 5px" )
        ]


imgsContainerStyle : Attribute a
imgsContainerStyle =
    style
        [ ( "text-align", "left" )
        ]


imgThumbnailContainerStyle : Attribute a
imgThumbnailContainerStyle =
    style
        [ ( "text-align", "left" )
        , ( "position", "relative" )
        , ( "display", "inline-block" )
        , ( "margin", "15px 20px 10px 0" )
        ]


imgThumbnailStyle : Attribute a
imgThumbnailStyle =
    style
        [ ( "width", "80px" )
        , ( "height", "80px" )
        ]


imgDeleteStyle : Attribute a
imgDeleteStyle =
    style
        [ ( "width", "10px" )
        , ( "height", "10px" )
        , ( "position", "absolute" )
        , ( "top", "-10px" )
        , ( "right", "-10px" )
        , ( "border-radius", "50%" )
        , ( "background", "red" )
        , ( "padding", "5px" )
        , ( "line-height", "0.8" )
        , ( "color", "white" )
        , ( "opacity", ".8" )
        ]
