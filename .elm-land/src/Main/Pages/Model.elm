module Main.Pages.Model exposing (Model(..))

import Pages.Home_
import Pages.Game10x10
import Pages.Game3x3
import Pages.Game5x5
import Pages.NotFound_
import View exposing (View)


type Model
    = Home_ Pages.Home_.Model
    | Game10x10 Pages.Game10x10.Model
    | Game3x3 Pages.Game3x3.Model
    | Game5x5 Pages.Game5x5.Model
    | NotFound_ Pages.NotFound_.Model
    | Redirecting_
    | Loading_
