module Main.Update exposing (mountRoute, update)

import Asset.Command
import Asset.Model
import Asset.Update
import CreateInitiative.Model
import CreateInitiative.Update
import Debug
import ExploreInitiatives.Command
import ExploreInitiatives.Update
import Homepage.Command
import Homepage.Update
import Main.Command exposing (logoutCmd)
import Main.Context exposing (DeviceSize(..))
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Main.Routing
    exposing
        ( Route(..)
        , loginPath
        , parseLocation
        )
import Material
import Navigation exposing (back, newUrl)
import Notification.Command
import Notification.Update
import Profile.Command
import Profile.Model
import Profile.Update
import UserLogin.Model
import UserLogin.Msg
import UserLogin.Update


mountRoute : Model -> ( Model, Cmd Msg )
mountRoute model =
    case model.context.route of
        HomepageRoute ->
            model
                ! [ Cmd.map HomepageMsg <| Homepage.Command.commands model.context model.homepage
                  , Cmd.map NotificationMsg <| Notification.Command.commands model.context
                  ]

        NotificationRoute ->
            model ! [ Cmd.map NotificationMsg <| Notification.Command.commands model.context ]

        AssetRoute _ ->
            { model | asset = Asset.Model.init }
                ! [ Cmd.map AssetMsg <| Asset.Command.commands model.context
                  , Cmd.map NotificationMsg <| Notification.Command.commands model.context
                  ]

        ProfileRoute _ ->
            { model | profile = Profile.Model.init }
                ! [ Cmd.map ProfileMsg <| Profile.Command.commands model.context
                  , Cmd.map NotificationMsg <| Notification.Command.commands model.context
                  ]

        ExploreInitiativesRoute ->
            model
                ! [ Cmd.map ExploreInitiativesMsg <| ExploreInitiatives.Command.commands model.context
                  , Cmd.map NotificationMsg <| Notification.Command.commands model.context
                  ]

        CreateInitiativeRoute ->
            model
                ! []

        UserForgotResetPassRoute userId token ->
            update (UserLoginMsg (UserLogin.Msg.InitForgotResetPass userId token)) model

        _ ->
            model ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ok =
            Debug.log (toString msg)
                ""
    in
    case msg of
        OnRouteChange location ->
            let
                context =
                    model.context

                userlogin =
                    UserLogin.Model.init
            in
            mountRoute
                { model
                    | userlogin = userlogin
                    , context = { context | route = parseLocation location }
                    , showMobileNav = False
                    , createInitiative = CreateInitiative.Model.init
                }

        OnCheckSessionResponse resp ->
            let
                context =
                    model.context
            in
            case resp of
                Ok user ->
                    { model | context = { context | user = Just user, sessionDidLoad = True } } ! []

                Err _ ->
                    { model | context = { context | sessionDidLoad = True } } ! []

        OnLogoutResponse resp ->
            case resp of
                Ok _ ->
                    let
                        context =
                            model.context

                        cmd =
                            case context.user of
                                Just _ ->
                                    []

                                _ ->
                                    [ newUrl loginPath ]
                    in
                    { model | context = { context | user = Nothing } } ! cmd

                Err _ ->
                    model ! []

        UserLoginMsg msg_ ->
            let
                ( userlogin, userloginCmd ) =
                    UserLogin.Update.update model.context msg_ model.userlogin

                context =
                    model.context

                user =
                    case userlogin.user of
                        Just _ ->
                            userlogin.user

                        _ ->
                            context.user

                cmd =
                    case userlogin.user of
                        Just _ ->
                            if userlogin.isNewUser then
                                [ newUrl "#" ]

                            else
                                [ newUrl "#" ]

                        _ ->
                            [ Cmd.map UserLoginMsg userloginCmd ]
            in
            { model | userlogin = userlogin, context = { context | user = user } } ! cmd

        UserLogout ->
            let
                context =
                    model.context
            in
            { model | context = { context | user = Nothing } } ! [ logoutCmd context model ]

        NotificationMsg msg_ ->
            let
                ( childModel, cmd ) =
                    Notification.Update.update model.context msg_ model.notification
            in
            { model | notification = childModel } ! [ Cmd.map NotificationMsg cmd ]

        HomepageMsg msg_ ->
            let
                ( childModel, homepageCmd ) =
                    Homepage.Update.update model.context msg_ model.homepage

                context =
                    model.context

                user =
                    case childModel.user of
                        Just _ ->
                            childModel.user

                        _ ->
                            context.user

                cmd =
                    [ Cmd.map HomepageMsg homepageCmd ]
            in
            { model
                | homepage = childModel
                , context = { context | user = user }
            }
                ! cmd

        AssetMsg msg_ ->
            let
                ( childModel, cmd ) =
                    Asset.Update.update model.context msg_ model.asset
            in
            { model | asset = childModel } ! [ Cmd.map AssetMsg cmd ]

        ProfileMsg msg_ ->
            let
                ( childModel, cmd ) =
                    Profile.Update.update model.context msg_ model.profile
            in
            { model | profile = childModel } ! [ Cmd.map ProfileMsg cmd ]

        ExploreInitiativesMsg msg_ ->
            let
                ( childModel, cmd ) =
                    ExploreInitiatives.Update.update model.context msg_ model.exploreInitiatives
            in
            { model | exploreInitiatives = childModel } ! [ Cmd.map ExploreInitiativesMsg cmd ]

        CreateInitiativeMsg msg_ ->
            let
                ( childModel, cmd ) =
                    CreateInitiative.Update.update model.context msg_ model.createInitiative
            in
            { model | createInitiative = childModel } ! [ Cmd.map CreateInitiativeMsg cmd ]

        OnWindowResize size ->
            let
                device =
                    if size.width <= 950 then
                        Mobile

                    else
                        Desktop

                window =
                    { width = size.width
                    , height = size.height
                    , device = device
                    , isMobile = device == Mobile
                    }

                context =
                    model.context
            in
            { model | context = { context | window = window } } ! []

        ToggleMobileNav ->
            { model | showMobileNav = not model.showMobileNav } ! []

        ToggleProfileMenu ->
            { model | showUserMenu = not model.showUserMenu } ! []

        MdlMsg msg_ ->
            Material.update MdlMsg msg_ model
