module UserLogin.ViewLogin exposing (helperStyle, loginWrapStyle, onKeyDown, render)

--import Html.Events exposing (..)

import Common.Error exposing (renderHttpError)
import Debug exposing (log)
import Html exposing (..)
import Html.Attributes exposing (href, style)
import Html.Events exposing (keyCode, on)
import Json.Decode as JD
import Main.Routing exposing (forgotPassPath, loginPath, signupPath)
import Material.Button as Button
import Material.Elevation as Elevation
import Material.Options as Options
import Material.Textfield as Textfield
import RemoteData exposing (RemoteData)
import UserLogin.Model exposing (Model)
import UserLogin.Msg exposing (Msg(..))


onKeyDown : (Int -> msg) -> Options.Property c msg
onKeyDown tagger =
    Options.on "keydown" (JD.map tagger keyCode)


render : Model -> Html Msg
render model =
    div [ loginWrapStyle ]
        [ h1 [] [ text "Log in" ]
        , div []
            [ Textfield.render Mdl
                [ 1 ]
                model.mdl
                [ Textfield.label "Email"
                , Textfield.floatingLabel
                , Textfield.email
                , Textfield.value model.email
                , Options.onInput SetEmail
                ]
                []
            ]
        , div []
            [ Textfield.render Mdl
                [ 2 ]
                model.mdl
                [ Textfield.label "Password"
                , Textfield.floatingLabel
                , Textfield.password
                , Textfield.value model.password
                , Options.onInput SetPassword
                , onKeyDown OnKeyDownLogin
                ]
                []
            ]
        , renderHttpError model.loginError
        , div []
            [ Button.render Mdl
                [ 3 ]
                model.mdl
                [ Button.ripple
                , Button.colored
                , Button.raised
                , Options.onClick DoLogin
                , Options.disabled model.isLoggingIn
                ]
                [ text "Log in" ]
            ]
        , div [ helperStyle ]
            [ a [ href forgotPassPath ] [ text "Forgot Password?" ]
            ]
        ]


loginWrapStyle : Attribute Msg
loginWrapStyle =
    style
        [ ( "margin", "0 auto" )
        , ( "max-width", "800px" )
        , ( "text-align", "center" )
        , ( "padding-top", "100px" )
        ]


helperStyle =
    style
        [ ( "padding-top", "30px" )
        ]
