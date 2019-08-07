module Timeline.Model exposing
    ( Emoji
    , Emojis
    , Model
    , PostReaction
    , TimelineEntries
    , TimelineEntry
    , TimelineFilter(..)
    , TimelineType(..)
    , emojisDecoder
    , init
    , timelineEntriesDecoder
    )

import Dict exposing (Dict)
import Gallery
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JP
import Material


type TimelineType
    = UserTimeline Int
    | HomepageTimeline
    | AssetTimeline Int


type TimelineFilter
    = AllFilter
    | FollowingFilter


type alias PostReaction =
    { users : List Int
    , id : Int
    , name : String
    , logo : String
    }


type alias TimelineEntry =
    { blockId : Int
    , userId : Int
    , userName : String
    , userProfileImageURL : String
    , assetId : Int
    , assetName : String
    , assetSymbol : String
    , oracleId : Int
    , oracleName : String
    , text : String
    , status : Int
    , ethereumTransactionAddress : String
    , ytVideoId : String
    , favoritesCount : Int
    , didUserLike : Bool
    , createdAt : String
    , createdAtHuman : String
    , images : List String
    , reactions : List PostReaction
    }


type alias TimelineEntries =
    { hasMore : Bool
    , page : Int
    , entries : List TimelineEntry
    }


type alias Emoji =
    { id : Int
    , name : String
    , logo : String
    }


type alias Emojis =
    { entries : List Emoji
    }


type alias Model =
    { mdl : Material.Model
    , timelineType : TimelineType
    , timelineFilter : TimelineFilter
    , data : Maybe TimelineEntries
    , gallery : Dict Int Gallery.State
    , isLoadingMore : Bool
    , loadMoreError : Maybe Http.Error
    , emojis : Maybe Emojis
    , entryEmojiKeyboard : Maybe TimelineEntry
    , error : Maybe Http.Error
    }


init : TimelineType -> Model
init timelineType =
    { mdl = Material.model
    , timelineType = timelineType
    , timelineFilter = AllFilter
    , data = Nothing
    , gallery = Dict.empty
    , isLoadingMore = False
    , loadMoreError = Nothing
    , emojis = Nothing
    , error = Nothing
    , entryEmojiKeyboard = Nothing
    }


timelineEntriesDecoder : JD.Decoder TimelineEntries
timelineEntriesDecoder =
    JP.decode TimelineEntries
        |> JP.required "HasMore" JD.bool
        |> JP.required "Page" JD.int
        |> JP.required "Entries" (JD.list timelineEntryDecoder)


emojisDecoder : JD.Decoder Emojis
emojisDecoder =
    JP.decode Emojis
        |> JP.required "Entries" (JD.list emojiDecoder)


emojiDecoder : JD.Decoder Emoji
emojiDecoder =
    JP.decode Emoji
        |> JP.required "ID" JD.int
        |> JP.required "Name" JD.string
        |> JP.required "Logo" JD.string


timelineEntryDecoder : JD.Decoder TimelineEntry
timelineEntryDecoder =
    JP.decode TimelineEntry
        |> JP.required "BlockID" JD.int
        |> JP.required "UserID" JD.int
        |> JP.required "UserName" JD.string
        |> JP.required "UserProfileImageURL" JD.string
        |> JP.required "AssetID" JD.int
        |> JP.required "AssetName" JD.string
        |> JP.required "AssetSymbol" JD.string
        |> JP.required "OracleID" JD.int
        |> JP.required "OracleName" JD.string
        |> JP.required "Text" JD.string
        |> JP.required "Status" JD.int
        |> JP.required "EthereumTransactionAddress" JD.string
        |> JP.required "YtVideoID" JD.string
        |> JP.required "FavoritesCount" JD.int
        |> JP.required "DidUserLike" JD.bool
        |> JP.required "CreatedAt" JD.string
        |> JP.required "CreatedAtHuman" JD.string
        |> JP.optional "Images" (JD.list JD.string) []
        |> JP.optional "Reactions" (JD.list postReactionDecoder) []


postReactionDecoder : JD.Decoder PostReaction
postReactionDecoder =
    JP.decode PostReaction
        |> JP.optional "Users" (JD.list JD.int) []
        |> JP.required "EmojiID" JD.int
        |> JP.required "EmojiName" JD.string
        |> JP.required "EmojiLogo" JD.string
