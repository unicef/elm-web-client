module Notification.Msg exposing (Msg(..))

import Http
import Material
import Notification.Model exposing (Message)


type Msg
    = Mdl (Material.Msg Msg)
    | OnLoadNotificationResponse (Result Http.Error (List Message))
    | MarkAsRead Int
    | OnMarkAsReadResponse (Result Http.Error {})
    | MarkAllAsRead
    | OnMarkAllAsReadResponse (Result Http.Error {})
