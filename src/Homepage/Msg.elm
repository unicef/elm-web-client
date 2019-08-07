module Homepage.Msg exposing (Msg(..))

import Http
import Main.User exposing (User)
import Material
import Timeline.Msg


type Msg
    = Mdl (Material.Msg Msg)
    | TimelineMsg Timeline.Msg.Msg
    | SetName String
    | OnLoginResponse (Result Http.Error User)
    | DoLogin
