module Common.Date exposing (render)

import Date.Extra as Date
import Html exposing (..)


render strDate =
    case Date.fromIsoString strDate of
        Just date ->
            span []
                [ text <| Date.toFormattedString "y-MM-dd" date
                , text " "
                , text <| Date.toFormattedString "HH:mm" date
                ]

        Nothing ->
            text "invalid:date"
