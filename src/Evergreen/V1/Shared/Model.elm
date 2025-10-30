module Evergreen.V1.Shared.Model exposing (..)


type alias LeaderboardEntry =
    { name : String
    , time : Int
    , mistakes : Int
    }


type alias Model =
    { leaderboard : List LeaderboardEntry
    }
