module Evergreen.V4.Shared.Model exposing (..)


type alias LeaderboardEntry =
    { name : String
    , gameName : String
    , time : Int
    , mistakes : Int
    , timestamp : Int
    }


type alias Model =
    { leaderboard3x3 : List LeaderboardEntry
    , leaderboard5x5 : List LeaderboardEntry
    , leaderboard10x10 : List LeaderboardEntry
    }
