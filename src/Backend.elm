module Backend exposing (Model, app)

import Bridge exposing (ToBackend(..))
import Lamdera exposing (ClientId, SessionId)
import Types exposing (BackendModel, BackendMsg(..), ToFrontend(..))


type alias Model =
    BackendModel


app :
    { init : ( Model, Cmd BackendMsg )
    , update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
    , updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
    , subscriptions : Model -> Sub BackendMsg
    }
app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \_ -> Lamdera.onConnect (\_ clientId -> OnConnect clientId)
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { leaderboard3x3 = []
      , leaderboard5x5 = []
      , leaderboard10x10 = []
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        OnConnect cid ->
            ( model
            , Lamdera.sendToFrontend cid <|
                NewLeaderboards
                    { leaderboard3x3 = model.leaderboard3x3
                    , leaderboard5x5 = model.leaderboard5x5
                    , leaderboard10x10 = model.leaderboard10x10
                    }
            )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend _ _ msg model =
    case msg of
        SubmitScore gameName name time mistakes timestamp ->
            let
                newEntry : Types.LeaderboardEntry
                newEntry =
                    { name = name, gameName = gameName, time = time, mistakes = mistakes, timestamp = timestamp }

                updateLeaderboard : List Types.LeaderboardEntry -> List Types.LeaderboardEntry
                updateLeaderboard leaderboard =
                    (newEntry :: leaderboard)
                        |> List.sortBy (\entry -> entry.time * 100 + entry.mistakes)
                        |> List.take 10

                newModel : Model
                newModel =
                    case gameName of
                        "3x3" ->
                            { model | leaderboard3x3 = updateLeaderboard model.leaderboard3x3 }

                        "5x5" ->
                            { model | leaderboard5x5 = updateLeaderboard model.leaderboard5x5 }

                        "10x10" ->
                            { model | leaderboard10x10 = updateLeaderboard model.leaderboard10x10 }

                        _ ->
                            model
            in
            ( newModel
            , Lamdera.broadcast <|
                NewLeaderboards
                    { leaderboard3x3 = newModel.leaderboard3x3
                    , leaderboard5x5 = newModel.leaderboard5x5
                    , leaderboard10x10 = newModel.leaderboard10x10
                    }
            )
