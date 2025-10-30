module Evergreen.V1.Bridge exposing (..)


type ToBackend
    = SubmitScore String Int Int
    | RequestLeaderboard
