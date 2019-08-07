module Homepage.Homepage exposing (render)

import Homepage.Msg exposing (Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Main.Context exposing (Context)


render : Context -> Html Msg
render ctx =
    div
        [ style
            [ ( "text-align", "center" )
            , ( "padding", "50px 10px" )
            , ( "width", "100%" )
            ]
        ]
        [ text "home"
        ]
