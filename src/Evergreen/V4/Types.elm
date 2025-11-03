module Evergreen.V4.Types exposing (..)

import Evergreen.V4.Bridge
import Evergreen.V4.Main
import Lamdera


type alias FrontendModel =
    Evergreen.V4.Main.Model


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
    Evergreen.V4.Main.Msg


type alias ToBackend =
    Evergreen.V4.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.ClientId


type ToFrontend
    = NewLeaderboards
        { leaderboard3x3 : List LeaderboardEntry
        , leaderboard5x5 : List LeaderboardEntry
        , leaderboard10x10 : List LeaderboardEntry
        }
