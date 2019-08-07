module Homepage.NotAuth exposing (render)

import Common.Colors as Colors
import Common.Error exposing (renderHttpError)
import Common.Styles
    exposing
        ( margin
        , marginBottom
        , marginTop
        , padding
        , paddingBottom
        , paddingLeft
        , paddingTop
        , textCenter
        , textLeft
        , toMdlCss
        )
import Homepage.Model exposing (Model)
import Homepage.Msg exposing (Msg(..))
import Html exposing (..)
import Html.Attributes
    exposing
        ( disabled
        , href
        , placeholder
        , src
        , style
        , target
        , type_
        , value
        )
import Html.Events exposing (onClick, onInput)
import Main.Context exposing (Context)
import Main.Routing exposing (loginPath, signupPath)


render : Context -> Model -> Html Msg
render ctx model =
    div [ textCenter, marginTop 30 ]
        [ header [ marginBottom 30 ] [ text "Prototype" ]
        , renderHttpError model.loginError
        , div
            []
            [ input
                [ placeholder "Enter a nickname?"
                , value model.name
                , onInput SetName
                , style
                    [ ( "padding", "15px" )
                    , ( "margin-top", "10px" )
                    , ( "border", "1px solid #ddd" )
                    , ( "width", "166px" )
                    ]
                ]
                []
            ]
        , div []
            [ button
                [ onClick DoLogin
                , disabled model.isLoggingIn
                , style
                    [ ( "padding", "15px" )
                    , ( "margin-top", "10px" )
                    , ( "margin-bottom", "10px" )
                    , ( "border", "1px solid #ddd" )
                    , ( "width", "200px" )
                    , ( "cursor", "pointer" )
                    , ( "background", Colors.secondary )
                    , ( "color", "white" )
                    ]
                ]
                [ case model.isLoggingIn of
                    True ->
                        text "One moment..."

                    False ->
                        text "Start"
                ]
            ]
        , div
            [ padding 30
            ]
            [ text "DISCLAIMER: BE AWARE THAT THIS IS A PROTOTYPE FOR "
            , b [] [ text "TESTING" ]
            , text " PURPOSES. PLEASE "
            , b [] [ text "DO NOT " ]
            , text "USE ANY SENSITIVE DATA"
            ]
        , div [ marginTop 30 ]
            [ a
                [ href "https://twitter.com/UNICEFinnovate"
                , target "__blank"
                ]
                [ text "@UNICEFInnovate" ]
            ]
        ]
