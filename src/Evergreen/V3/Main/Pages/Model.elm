module Evergreen.V3.Main.Pages.Model exposing (..)

import Evergreen.V3.Pages.Game10x10
import Evergreen.V3.Pages.Game3x3
import Evergreen.V3.Pages.Game5x5
import Evergreen.V3.Pages.Home_
import Evergreen.V3.Pages.NotFound_


type Model
    = Home_ Evergreen.V3.Pages.Home_.Model
    | Game10x10 Evergreen.V3.Pages.Game10x10.Model
    | Game3x3 Evergreen.V3.Pages.Game3x3.Model
    | Game5x5 Evergreen.V3.Pages.Game5x5.Model
    | NotFound_ Evergreen.V3.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
