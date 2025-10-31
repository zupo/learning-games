module Util exposing (shuffle)

import Random


shuffle : List a -> Random.Generator (List a)
shuffle list =
    let
        randomNumbers : Random.Generator (List Float)
        randomNumbers =
            Random.list (List.length list) (Random.float 0 1)
    in
    randomNumbers
        |> Random.map
            (\randoms ->
                List.map2 Tuple.pair list randoms
                    |> List.sortBy Tuple.second
                    |> List.map Tuple.first
            )
