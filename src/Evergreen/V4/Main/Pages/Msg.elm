module Evergreen.V4.Main.Pages.Msg exposing (..)

import Evergreen.V4.Pages.Game10x10
import Evergreen.V4.Pages.Game3x3
import Evergreen.V4.Pages.Game5x5
import Evergreen.V4.Pages.Home_
import Evergreen.V4.Pages.NotFound_


type Msg
    = Home_ Evergreen.V4.Pages.Home_.Msg
    | Game10x10 Evergreen.V4.Pages.Game10x10.Msg
    | Game3x3 Evergreen.V4.Pages.Game3x3.Msg
    | Game5x5 Evergreen.V4.Pages.Game5x5.Msg
    | NotFound_ Evergreen.V4.Pages.NotFound_.Msg
