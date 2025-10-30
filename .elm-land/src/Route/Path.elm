module Route.Path exposing (Path(..), fromString, fromUrl, href, toString)

import Html
import Html.Attributes
import Url exposing (Url)
import Url.Parser exposing ((</>))


type Path
    = Home_
    | Game10x10
    | Game3x3
    | Game5x5
    | NotFound_


fromUrl : Url -> Path
fromUrl url =
    fromString url.path
        |> Maybe.withDefault NotFound_


fromString : String -> Maybe Path
fromString urlPath =
    let
        urlPathSegments : List String
        urlPathSegments =
            urlPath
                |> String.split "/"
                |> List.filter (String.trim >> String.isEmpty >> Basics.not)
    in
    case urlPathSegments of
        [] ->
            Just Home_

        "game10x10" :: [] ->
            Just Game10x10

        "game3x3" :: [] ->
            Just Game3x3

        "game5x5" :: [] ->
            Just Game5x5

        _ ->
            Nothing


href : Path -> Html.Attribute msg
href path =
    Html.Attributes.href (toString path)


toString : Path -> String
toString path =
    let
        pieces : List String
        pieces =
            case path of
                Home_ ->
                    []

                Game10x10 ->
                    [ "game10x10" ]

                Game3x3 ->
                    [ "game3x3" ]

                Game5x5 ->
                    [ "game5x5" ]

                NotFound_ ->
                    [ "404" ]
    in
    pieces
        |> String.join "/"
        |> String.append "/"
