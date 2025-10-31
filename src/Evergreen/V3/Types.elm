module Evergreen.V3.Types exposing (..)

import Evergreen.V3.Bridge
import Evergreen.V3.Main
import Lamdera


type alias FrontendModel =
    Evergreen.V3.Main.Model


type alias LeaderboardEntry =
    { name : String
    , gameName : String
    , time : Int
    , mistakes : Int
    , timestamp : Int
    }


type alias BackendModel =
    { leaderboard3x3 : List LeaderboardEntry
    , leaderboard5x5 : List LeaderboardEntry
    , leaderboard10x10 : List LeaderboardEntry
    }


type alias FrontendMsg =
    Evergreen.V3.Main.Msg


type alias ToBackend =
    Evergreen.V3.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.ClientId


type ToFrontend
    = NewLeaderboards
        { leaderboard3x3 : List LeaderboardEntry
        , leaderboard5x5 : List LeaderboardEntry
        , leaderboard10x10 : List LeaderboardEntry
        }
