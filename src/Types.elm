module Types exposing (BackendModel, BackendMsg(..), FrontendModel, FrontendMsg, LeaderboardEntry, ToBackend, ToFrontend(..))

import Bridge
import Lamdera exposing (ClientId)
import Main as ElmLand


type alias FrontendModel =
    ElmLand.Model


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
    ElmLand.Msg


type alias ToBackend =
    Bridge.ToBackend


type BackendMsg
    = OnConnect ClientId


type ToFrontend
    = NewLeaderboards
        { leaderboard3x3 : List LeaderboardEntry
        , leaderboard5x5 : List LeaderboardEntry
        , leaderboard10x10 : List LeaderboardEntry
        }
