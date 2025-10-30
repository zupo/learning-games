module Shared.Model exposing (LeaderboardEntry, Model)

{-| -}


{-| Normally, this value would live in "Shared.elm"
but that would lead to a circular dependency import cycle.

For that reason, both `Shared.Model` and `Shared.Msg` are in their
own file, so they can be imported by `Effect.elm`

-}
type alias Model =
    { leaderboard3x3 : List LeaderboardEntry
    , leaderboard5x5 : List LeaderboardEntry
    , leaderboard10x10 : List LeaderboardEntry
    }


type alias LeaderboardEntry =
    { name : String
    , gameName : String
    , time : Int
    , mistakes : Int
    , timestamp : Int
    }
