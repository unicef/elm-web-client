module Main.Msg exposing (Msg(..))

-- import Chat.Msg

import Asset.Msg
import Common.Json exposing (EmptyResponse)
import CreateInitiative.Msg
import ExploreInitiatives.Msg
import Homepage.Msg
import Http
import Main.User exposing (User)
import Material
import Navigation exposing (Location)
import Notification.Msg
import Profile.Msg
import UserLogin.Msg
import Window


type Msg
    = OnRouteChange Location
    | ToggleMobileNav
    | ToggleProfileMenu
    | OnCheckSessionResponse (Result Http.Error User)
    | MdlMsg (Material.Msg Msg)
    | OnWindowResize Window.Size
    | UserLoginMsg UserLogin.Msg.Msg
    | UserLogout
    | OnLogoutResponse (Result Http.Error EmptyResponse)
    | HomepageMsg Homepage.Msg.Msg
    | ExploreInitiativesMsg ExploreInitiatives.Msg.Msg
    | CreateInitiativeMsg CreateInitiative.Msg.Msg
    | AssetMsg Asset.Msg.Msg
    | ProfileMsg Profile.Msg.Msg
    | NotificationMsg Notification.Msg.Msg
