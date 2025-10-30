module Main.Pages.Msg exposing (Msg(..))

import Pages.Home_
import Pages.Game10x10
import Pages.Game3x3
import Pages.Game5x5
import Pages.NotFound_


type Msg
    = Home_ Pages.Home_.Msg
    | Game10x10 Pages.Game10x10.Msg
    | Game3x3 Pages.Game3x3.Msg
    | Game5x5 Pages.Game5x5.Msg
    | NotFound_ Pages.NotFound_.Msg
