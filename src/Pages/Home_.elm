module Pages.Home_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Html.Styled exposing (a, div, h1, text)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Shared.Model exposing (LeaderboardEntry)
import Tailwind.Utilities as Tw
import Time
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared _ =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = Never


update : Msg -> Model -> ( Model, Effect Msg )
update _ model =
    ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared _ =
    { title = "Learning Games"
    , body =
        [ h1
            [ css
                [ Tw.text_4xl
                , Tw.font_bold
                , Tw.text_center
                , Tw.my_16
                ]
            ]
            [ text "Learning Games" ]
        , div
            [ css
                [ Tw.max_w_6xl
                , Tw.mx_auto
                , Tw.px_4
                ]
            ]
            [ div
                [ css
                    [ Tw.flex
                    , Tw.gap_8
                    , Tw.justify_center
                    ]
                ]
                [ -- 3x3 Game Section
                  div
                    [ css
                        [ Tw.flex_1
                        , Tw.max_w_sm
                        ]
                    ]
                    [ div
                        [ css
                            [ Tw.flex
                            , Tw.justify_center
                            , Tw.mb_4
                            ]
                        ]
                        [ a
                            [ href "/game3x3"
                            , css
                                [ Tw.px_6
                                , Tw.py_3
                                , Tw.border
                                , Tw.border_solid
                                , Tw.rounded
                                , Tw.font_bold
                                , Tw.cursor_pointer
                                , Tw.text_xl
                                ]
                            ]
                            [ text "Play 3x3" ]
                        ]
                    , viewLeaderboard "Leaderboard" shared.leaderboard3x3
                    ]
                , -- 5x5 Game Section
                  div
                    [ css
                        [ Tw.flex_1
                        , Tw.max_w_sm
                        ]
                    ]
                    [ div
                        [ css
                            [ Tw.flex
                            , Tw.justify_center
                            , Tw.mb_4
                            ]
                        ]
                        [ a
                            [ href "/game5x5"
                            , css
                                [ Tw.px_6
                                , Tw.py_3
                                , Tw.border
                                , Tw.border_solid
                                , Tw.rounded
                                , Tw.font_bold
                                , Tw.cursor_pointer
                                , Tw.text_xl
                                ]
                            ]
                            [ text "Play 5x5" ]
                        ]
                    , viewLeaderboard "Leaderboard" shared.leaderboard5x5
                    ]
                , -- 10x10 Game Section
                  div
                    [ css
                        [ Tw.flex_1
                        , Tw.max_w_sm
                        ]
                    ]
                    [ div
                        [ css
                            [ Tw.flex
                            , Tw.justify_center
                            , Tw.mb_4
                            ]
                        ]
                        [ a
                            [ href "/game10x10"
                            , css
                                [ Tw.px_6
                                , Tw.py_3
                                , Tw.border
                                , Tw.border_solid
                                , Tw.rounded
                                , Tw.font_bold
                                , Tw.cursor_pointer
                                , Tw.text_xl
                                ]
                            ]
                            [ text "Play 10x10" ]
                        ]
                    , viewLeaderboard "Leaderboard" shared.leaderboard10x10
                    ]
                ]
            ]
        ]
    }


formatTime : Int -> String
formatTime seconds =
    let
        mins : Int
        mins =
            seconds // 60

        secs : Int
        secs =
            modBy 60 seconds
    in
    String.fromInt mins ++ ":" ++ String.padLeft 2 '0' (String.fromInt secs)


viewLeaderboard : String -> List LeaderboardEntry -> Html.Styled.Html Msg
viewLeaderboard title entries =
    div
        [ css
            [ Tw.mt_20
            ]
        ]
        [ div
            [ css
                [ Tw.text_xl
                , Tw.font_bold
                , Tw.mb_2
                , Tw.text_center
                ]
            ]
            [ text title ]
        , if List.isEmpty entries then
            div
                [ css
                    [ Tw.text_center
                    , Tw.p_2
                    , Tw.mb_1
                    ]
                ]
                [ text "No scores yet. Be the first!" ]

          else
            div []
                (List.indexedMap viewLeaderboardEntry entries)
        ]


viewLeaderboardEntry : Int -> LeaderboardEntry -> Html.Styled.Html Msg
viewLeaderboardEntry index entry =
    div
        [ css
            [ Tw.p_2
            , Tw.mb_1
            ]
        ]
        [ div
            [ css
                [ Tw.flex
                , Tw.justify_between
                ]
            ]
            [ div [] [ text (String.fromInt (index + 1) ++ ". " ++ entry.name) ]
            , div [] [ text (formatTime entry.time ++ " | " ++ String.fromInt entry.mistakes ++ " mistakes") ]
            ]
        , div
            [ css
                [ Tw.text_sm
                , Tw.opacity_75
                , Tw.ml_4
                ]
            ]
            [ text (formatTimestamp entry.timestamp) ]
        ]


formatTimestamp : Int -> String
formatTimestamp millis =
    let
        posix : Time.Posix
        posix =
            Time.millisToPosix millis

        year : Int
        year =
            Time.toYear Time.utc posix

        month : String
        month =
            case Time.toMonth Time.utc posix of
                Time.Jan ->
                    "01"

                Time.Feb ->
                    "02"

                Time.Mar ->
                    "03"

                Time.Apr ->
                    "04"

                Time.May ->
                    "05"

                Time.Jun ->
                    "06"

                Time.Jul ->
                    "07"

                Time.Aug ->
                    "08"

                Time.Sep ->
                    "09"

                Time.Oct ->
                    "10"

                Time.Nov ->
                    "11"

                Time.Dec ->
                    "12"

        day : String
        day =
            Time.toDay Time.utc posix
                |> String.fromInt
                |> String.padLeft 2 '0'

        hour : String
        hour =
            Time.toHour Time.utc posix
                |> String.fromInt
                |> String.padLeft 2 '0'

        minute : String
        minute =
            Time.toMinute Time.utc posix
                |> String.fromInt
                |> String.padLeft 2 '0'

        second : String
        second =
            Time.toSecond Time.utc posix
                |> String.fromInt
                |> String.padLeft 2 '0'
    in
    String.fromInt year ++ "-" ++ month ++ "-" ++ day ++ " " ++ hour ++ ":" ++ minute ++ ":" ++ second
