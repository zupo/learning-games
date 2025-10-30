module Evergreen.V1.Shared.Msg exposing (..)

import Evergreen.V1.Shared.Model


type Msg
    = GotLeaderboard (List Evergreen.V1.Shared.Model.LeaderboardEntry)
