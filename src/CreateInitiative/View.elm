module CreateInitiative.View exposing (render)

import Common.Colors as Colors
import Common.Error exposing (renderHttpError)
import Common.Styles exposing (margin, marginBottom, marginTop, padding, textCenter)
import Common.Typo as Typo
import CreateInitiative.Model exposing (Model)
import CreateInitiative.Msg exposing (Msg(..))
import CreateInitiative.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Identicon exposing (identicon)
import List exposing (append)
import Main.Context exposing (Context)
import Main.Routing exposing (assetPath, exploreInitiativesPath)
import Material
import Material.Button as Button
import Material.Card as Card
import Material.Chip as Chip
import Material.Icon as Icon
import Material.Options as Options exposing (css)
import Material.Spinner
import Material.Textfield as Textfield
import Navigation exposing (back)


render : Context -> Model -> Html Msg
render ctx model =
    div []
        [ div
            [ style
                [ ( "text-align", "center" )
                , ( "text-size", Typo.s1 )
                , ( "padding", "15px 0" )
                , ( "display", "flex" )
                ]
            ]
            [ rennderBackButton
            , b
                [ style
                    [ ( "flex-grow", "1" )
                    , ( "padding", "5px 0" )
                    ]
                ]
                [ case model.step of
                    ProjectDetails ->
                        text "Initiative details"

                    GitProjectDetails ->
                        text "Git project"

                    _ ->
                        text ""
                ]
            , renderNextButton model
            ]
        , div [ stepBodyStyle ]
            [ case model.step of
                ProjectType ->
                    div []
                        [ div
                            [ onClick (SetActiveView GitProjectDetails)
                            , projectItemStyle
                            ]
                            [ text "Open-source project"
                            ]
                        , div
                            [ onClick (SetActiveView ProjectDetails)
                            , projectItemStyle
                            ]
                            [ text "Discussion topic"
                            ]
                        ]

                GitProjectDetails ->
                    div []
                        [ div []
                            [ p [ hintStle ] [ text "Repository link" ]
                            , input
                                [ inputStyle
                                , value model.gitLink
                                , onInput SetGitLink
                                , placeholder "e.g github.com/unicef/magicbox.git"
                                ]
                                []
                            , renderButton (LoadGitRepo model.gitLink) "Fetch"
                            ]
                        ]

                ProjectDetails ->
                    renderInitiative ctx model

                TokenDetails ->
                    renderToken ctx model

                SuccessView ->
                    renderSuccess ctx model
            ]
        ]


projectItemStyle : Attribute a
projectItemStyle =
    style
        [ ( "border", "1px solid #ddd" )
        , ( "padding", "15px" )
        , ( "cursor", "pointer" )
        , ( "margin-bottom", "15px" )
        , ( "color", Colors.secondary )
        ]


rennderBackButton : Html Msg
rennderBackButton =
    div
        [ style
            [ ( "width", "45px" )
            , ( "display", "inline-block" )
            , ( "padding", "5px 5px 5px 30px" )
            , ( "color", Colors.secondary )
            ]
        , onClick Back
        ]
        [ text "Close"
        ]


renderNextButton : Model -> Html Msg
renderNextButton model =
    div
        [ style
            [ ( "width", "45px" )
            , ( "display", "inline-block" )
            , ( "padding", "5px 30px 5px 5px" )
            ]
        ]
        []


renderToken : Context -> Model -> Html Msg
renderToken ctx model =
    div []
        [ div []
            [ p [ hintStle ] [ text "Symbol" ]
            , input
                [ inputStyle
                , value model.symbol
                , onInput SetSymbol
                , placeholder ""
                ]
                []
            ]
        , div []
            [ div [ hintStle ]
                [-- checkbox ToggleCapped "Cap"
                ]
            , case model.capped of
                True ->
                    input
                        [ inputStyle
                        , value model.cap
                        , onInput SetCap
                        , placeholder "e.g 1000"
                        ]
                        []

                False ->
                    span [] []
            ]
        , div [ marginTop 15, marginBottom 30 ]
            [ p [ hintStle ] [ text "Allocation" ]
            , div [] [ text "Contributor: 90%" ]
            , div [] [ text "Approver: 10%" ]
            , a [] [ text "edit" ]
            ]
        , renderButton (SetActiveView TokenDetails) "Create"
        ]


checkbox : Bool -> msg -> String -> Html msg
checkbox isChecked msg name =
    label []
        [ input
            [ type_ "checkbox"
            , onClick msg
            , checked isChecked
            ]
            []
        , text name
        ]


renderButton : Msg -> String -> Html Msg
renderButton msg_ label_ =
    button
        [ onClick msg_
        , buttonStyle
        ]
        [ text label_
        ]


renderInitiative : Context -> Model -> Html Msg
renderInitiative ctx model =
    div
        []
        [ div [ marginTop 30 ]
            [ p [ hintStle ] [ text "Name" ]
            , input
                [ inputStyle
                , value model.name
                , onInput SetName
                , placeholder "e.g Tree planting "
                ]
                []
            ]
        , div
            []
            [ p [ hintStle ] [ text "Purpose" ]
            , textarea
                [ textareaStyle
                , value model.purpose
                , onInput SetDescription
                , rows 5
                , placeholder "e.g plant a tree and get rewarded with a TREE token"
                ]
                []
            ]
        , renderHttpError model.createInitiativeError
        , button
            [ onClick (SetActiveView TokenDetails)
            , buttonStyle
            ]
            [ text "Next"
            ]
        , div [ textCenter, padding 15 ] [ text " OR " ]
        , button
            [ onClick (SetActiveView GitProjectDetails)
            , buttonStyle
            ]
            [ text "Load from a Git repository"
            ]
        ]


renderSuccess : Context -> Model -> Html Msg
renderSuccess ctx model =
    div
        [ style
            [ ( "text-align", "center" )
            , ( "padding-top", "45px" )
            ]
        ]
        [ header
            [ style
                [ ( "padding-bottom", "45px" )
                ]
            ]
            [ text "Congratulations" ]
        , div
            [ style
                [ ( "padding-bottom", "45px" )
                ]
            ]
            [ text "Your initiative has been successfully created"
            ]
        , a [ href (assetPath model.createdAssetId) ]
            [ text <|
                "Go to "
                    ++ model.createdAssetName
                    ++ " ("
                    ++ model.createdAssetSymbol
                    ++ ")"
            ]
        , div [ style [ ( "padding", "30px 0" ) ] ] [ text "OR" ]
        , a [ href exploreInitiativesPath ] [ text "Explore other initiatives" ]
        ]


stepBodyStyle : Attribute a
stepBodyStyle =
    style [ ( "margin", "15px 30px 60px 30px" ) ]


inputStyle : Attribute a
inputStyle =
    style
        [ ( "background-color", "#f2f2f2" )
        , ( "height", "50px" )
        , ( "border", "none" )
        , ( "padding", "15px" )
        , ( "width", "100%" )
        , ( "box-sizing", "border-box" )
        , ( "margin-bottom", "15px" )
        , ( "font-family", Typo.primaryFace )
        ]


textareaStyle : Attribute a
textareaStyle =
    style
        [ ( "background-color", "#f2f2f2" )
        , ( "border", "none" )
        , ( "padding", "15px" )
        , ( "width", "100%" )
        , ( "box-sizing", "border-box" )
        , ( "margin-bottom", "15px" )
        , ( "font-family", Typo.primaryFace )
        ]


identiconStyle : Attribute a
identiconStyle =
    style
        [ ( "width", "60px" )
        , ( "height", "60px" )
        , ( "border", "1px solid #ddd" )
        , ( "margin", "auto" )
        , ( "padding", "10px" )
        ]


hintStle : Attribute a
hintStle =
    style
        [ ( "margin", " 0" )
        , ( "padding-left", "2px" )
        ]


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
        , ( "width", "100%" )
        ]
