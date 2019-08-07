module Homepage.Update exposing (update)

import Homepage.Command exposing (commands, loginCmd)
import Homepage.Model exposing (Model)
import Homepage.Msg exposing (Msg(..))
import Main.Context exposing (Context)
import Material
import Navigation exposing (newUrl)
import Timeline.Update


update : Context -> Msg -> Model -> ( Model, Cmd Msg )
update ctx msg model =
    case msg of
        TimelineMsg msg_ ->
            let
                ( childModel, cmd ) =
                    Timeline.Update.update ctx msg_ model.timeline
            in
            { model | timeline = childModel } ! [ Cmd.map TimelineMsg cmd ]

        SetName name ->
            { model | name = name } ! []

        DoLogin ->
            { model
                | user = Nothing
                , isLoggingIn = True
                , loginError = Nothing
            }
                ! [ loginCmd ctx model ]

        OnLoginResponse res ->
            case res of
                Ok user ->
                    { model
                        | user = Just user
                        , isLoggingIn = False
                        , loginError = Nothing
                    }
                        ! [ newUrl "#" ]

                Err error ->
                    { model
                        | isLoggingIn = False
                        , loginError = Just error
                    }
                        ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model
