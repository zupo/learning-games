module Evergreen.V3.Shared.Msg exposing (..)

import Evergreen.V3.Shared.Model


type Msg
    = GotLeaderboards
        { leaderboard3x3 : List Evergreen.V3.Shared.Model.LeaderboardEntry
        , leaderboard5x5 : List Evergreen.V3.Shared.Model.LeaderboardEntry
        , leaderboard10x10 : List Evergreen.V3.Shared.Model.LeaderboardEntry
        }
