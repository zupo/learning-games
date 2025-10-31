module Evergreen.V4.Pages.Game3x3 exposing (..)

import Set
import Time


type alias Model =
    { clickedCells : Set.Set ( Int, Int )
    , targetNumbers : List Int
    , targetNumber : Int
    , timer : Int
    , isRunning : Bool
    , mistakes : Int
    , gameComplete : Bool
    , hoveredCell : Maybe ( Int, Int )
    , wrongCell : Maybe ( Int, Int )
    , showPenalty : Bool
    , playerName : String
    , scoreSaved : Bool
    }


type Msg
    = CellClicked Int Int
    | GotShuffledTargets (List Int)
    | Tick
    | CellHovered Int Int
    | CellUnhovered
    | ClearWrongCell
    | ClearPenalty
    | PlayerNameChanged String
    | SaveScore
    | GotTimestamp Time.Posix
