module Main.View exposing (view)

import Common.Colors as Colors
import Common.Spinner as Spinner
import Common.Styles exposing (paddingTop, textCenter, toMdlCss)
import Html exposing (..)
import Html.Attributes exposing (attribute, href, style)
import Html.Events exposing (onClick)
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Main.Routing exposing (Route(..))
import Main.ViewBody as ViewBody
import Main.ViewNavigation as ViewNavigation
import Material.Button as Button
import Material.Icon as Icon
import Material.Options as Options exposing (css)


view : Model -> Html Msg
view model =
    div [ bodyStyle model.context.window.isMobile ]
        [ case model.context.sessionDidLoad of
            False ->
                div [ textCenter, paddingTop 45 ]
                    [ p [] [ text "Prototype" ]
                    , Spinner.render "One moment..."
                    ]

            True ->
                div []
                    [ case model.context.user of
                        Nothing ->
                            span [] []

                        Just _ ->
                            -- hiding bottom menu for individual pages like (create asset and asset details)
                            -- Menu is visible only on the first navigation layer level (menu pages)
                            case model.context.route of
                                CreateInitiativeRoute ->
                                    span [] []

                                _ ->
                                    ViewNavigation.render model
                    , ViewBody.render model
                    ]
        ]


menuStyle isMobile =
    let
        ( top, width ) =
            case isMobile of
                True ->
                    ( "0", "100%" )

                False ->
                    ( "60px", "600px" )
    in
    style
        [ ( "width", "100%" )
        , ( "background", "#eee" )
        , ( "color", "black" )
        , ( "border-bottom", "1px solid #ddd" )
        , ( "text-align", "center" )
        , ( "height", "50px" )
        , ( "position", "fixed" )
        , ( "top", top )
        , ( "width", width )
        , ( "z-index", "10" )
        ]


bodyStyle : Bool -> Attribute a
bodyStyle isMobile =
    let
        ( w, marginTop ) =
            case isMobile of
                True ->
                    ( "100%", "0px" )

                False ->
                    ( "600px", "60px" )
    in
    style
        [ ( "width", w )
        , ( "margin", "0 auto 60px auto" )
        , ( "margin-top", marginTop )
        , ( "padding-bottom", "60px" )
        ]


headerStyle : Bool -> Attribute a
headerStyle isMobile =
    let
        ( w, pl ) =
            case isMobile of
                True ->
                    ( "inherit", "50px" )

                False ->
                    ( "600px", "10px" )
    in
    style
        [ ( "transition", "height 333ms ease-in-out 0s" )
        , ( "padding-left", pl )
        , ( "padding-top", "3px" )
        , ( "padding-right", "10px" )
        , ( "width", w )
        , ( "margin", "auto" )
        ]
