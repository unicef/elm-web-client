module Homepage.Model exposing (Model, init)

import Http
import Main.User exposing (User)
import Material
import Timeline.Model exposing (TimelineType(..))


type alias Model =
    { mdl : Material.Model
    , timeline : Timeline.Model.Model
    , name : String
    , user : Maybe User
    , loginError : Maybe Http.Error
    , isLoggingIn : Bool
    }


init : Model
init =
    { mdl = Material.model
    , timeline = Timeline.Model.init HomepageTimeline
    , name = ""
    , user = Nothing
    , loginError = Nothing
    , isLoggingIn = False
    }
