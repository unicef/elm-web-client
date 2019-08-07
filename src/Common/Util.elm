module Common.Util exposing (..)


assetLink : String -> String
assetLink path =
    "/static/" ++ path
