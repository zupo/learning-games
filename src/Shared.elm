module Shared exposing
    ( Flags, decoder
    , Model, Msg
    , init, update, subscriptions
    )

{-|

@docs Flags, decoder
@docs Model, Msg
@docs init, update, subscriptions

-}

import Effect exposing (Effect)
import Json.Decode
import Route exposing (Route)
import Shared.Model
import Shared.Msg



-- FLAGS


type alias Flags =
    {}


decoder : Json.Decode.Decoder Flags
decoder =
    Json.Decode.succeed {}



-- INIT


type alias Model =
    Shared.Model.Model


init : Result Json.Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init _ _ =
    ( { leaderboard3x3 = []
      , leaderboard5x5 = []
      , leaderboard10x10 = []
      }
    , Effect.none
    )



-- UPDATE


type alias Msg =
    Shared.Msg.Msg


update : Route () -> Msg -> Model -> ( Model, Effect Msg )
update _ msg model =
    case msg of
        Shared.Msg.GotLeaderboards { leaderboard3x3, leaderboard5x5, leaderboard10x10 } ->
            ( { model
                | leaderboard3x3 = leaderboard3x3
                , leaderboard5x5 = leaderboard5x5
                , leaderboard10x10 = leaderboard10x10
              }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
