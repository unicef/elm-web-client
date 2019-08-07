module Main.Model exposing (Model, initModel)

import Asset.Model
import CreateInitiative.Model
import ExploreInitiatives.Model
import Homepage.Model
import Main.Context exposing (Context, initContext)
import Main.Flags exposing (Flags)
import Main.Routing exposing (Route(..))
import Material
import Notification.Model
import Profile.Model
import UserLogin.Model


type alias Model =
    { v : String
    , context : Context
    , mdl : Material.Model
    , showMobileNav : Bool
    , showUserMenu : Bool
    , userlogin : UserLogin.Model.Model
    , exploreInitiatives : ExploreInitiatives.Model.Model
    , createInitiative : CreateInitiative.Model.Model
    , asset : Asset.Model.Model
    , profile : Profile.Model.Model
    , homepage : Homepage.Model.Model
    , notification : Notification.Model.Model
    }


initModel : Flags -> Route -> Model
initModel flags route =
    { v = "1"
    , context = initContext flags route
    , mdl = Material.model
    , showMobileNav = False
    , showUserMenu = False
    , userlogin = UserLogin.Model.init
    , exploreInitiatives = ExploreInitiatives.Model.init
    , createInitiative = CreateInitiative.Model.init
    , asset = Asset.Model.init
    , profile = Profile.Model.init
    , homepage = Homepage.Model.init
    , notification = Notification.Model.init
    }
