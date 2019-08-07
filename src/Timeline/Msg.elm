module Timeline.Msg exposing (Msg(..))

import Common.Json exposing (EmptyResponse)
import Gallery
import Http
import Material
import Timeline.Model
    exposing
        ( Emojis
        , TimelineEntries
        , TimelineEntry
        , TimelineFilter
        )


type Msg
    = Mdl (Material.Msg Msg)
    | OnLoadTimelineResponse (Result Http.Error TimelineEntries)
    | OnLoadEmojisResponse (Result Http.Error Emojis)
    | GalleryMsg Int Gallery.Msg
    | LoadMore
    | OnToggleFavoriteResponse (Result Http.Error {})
    | ToggleFavorite Int
    | VerifyBlock Bool Int
    | VerifyBlockResponse (Result Http.Error EmptyResponse)
    | SwitchFilter TimelineFilter
    | ToggleEmojiKeyboard (Maybe TimelineEntry)
    | SubmitReaction Int Int
    | OnSubmitReactionResponse (Result Http.Error {})
