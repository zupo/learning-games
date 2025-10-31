module Evergreen.V3.Main.Pages.Msg exposing (..)

import Evergreen.V3.Pages.Game10x10
import Evergreen.V3.Pages.Game3x3
import Evergreen.V3.Pages.Game5x5
import Evergreen.V3.Pages.Home_
import Evergreen.V3.Pages.NotFound_


type Msg
    = Home_ Evergreen.V3.Pages.Home_.Msg
    | Game10x10 Evergreen.V3.Pages.Game10x10.Msg
    | Game3x3 Evergreen.V3.Pages.Game3x3.Msg
    | Game5x5 Evergreen.V3.Pages.Game5x5.Msg
    | NotFound_ Evergreen.V3.Pages.NotFound_.Msg
