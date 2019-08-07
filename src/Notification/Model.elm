module Notification.Model exposing (Message, Model, init)

import Material


type alias Message =
    { id : Int
    , senderId : Int
    , senderName : String
    , receiverId : Int
    , receiverName : String
    , topicId : Int
    , topicName : String
    , topicSymbol : String
    , notificationType : Int
    , isRead : Bool
    , createdAt : String
    , createdAtHuman : String
    }


type alias Model =
    { mdl : Material.Model
    , entries : List Message
    , error : Maybe String
    }


init : Model
init =
    { mdl = Material.model
    , entries = []
    , error = Nothing
    }
