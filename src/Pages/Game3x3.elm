module Pages.Game3x3 exposing (Model, Msg(..), page)

import Bridge
import Effect exposing (Effect)
import Html.Styled exposing (a, button, div, input, text)
import Html.Styled.Attributes exposing (css, href, placeholder, type_, value)
import Html.Styled.Events exposing (on, onClick, onInput)
import Json.Decode
import Lamdera
import Page exposing (Page)
import Process
import Random
import Route exposing (Route)
import Set exposing (Set)
import Shared
import Shared.Model exposing (LeaderboardEntry)
import Tailwind.Utilities as Tw
import Task
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
    { clickedCells : Set ( Int, Int )
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


init : () -> ( Model, Effect Msg )
init _ =
    ( { clickedCells = Set.empty
      , targetNumber = 0
      , timer = 0
      , isRunning = True
      , mistakes = 0
      , gameComplete = False
      , hoveredCell = Nothing
      , wrongCell = Nothing
      , showPenalty = False
      , playerName = ""
      , scoreSaved = False
      }
    , Effect.sendCmd (Random.generate GotTargetNumber (generateTarget Set.empty 0))
    )


generateTarget : Set ( Int, Int ) -> Int -> Random.Generator Int
generateTarget clickedCells currentTarget =
    let
        allValidProducts : List Int
        allValidProducts =
            [ 1, 2, 3, 4, 6, 9 ]

        -- Filter out products where ALL cells producing that product are already clicked
        -- AND exclude the current target to force variety
        availableProducts : List Int
        availableProducts =
            allValidProducts
                |> List.filter
                    (\product ->
                        (product /= currentTarget)
                            && (List.range 1 3
                                    |> List.concatMap
                                        (\r ->
                                            List.range 1 3
                                                |> List.map (\c -> ( r, c ))
                                        )
                                    |> List.any
                                        (\( r, c ) ->
                                            (r * c == product)
                                                && not (Set.member ( r, c ) clickedCells)
                                        )
                               )
                    )

        listLength : Int
        listLength =
            List.length availableProducts
    in
    Random.int 0 (max 0 (listLength - 1))
        |> Random.map
            (\index ->
                List.drop index availableProducts
                    |> List.head
                    |> Maybe.withDefault 1
            )



-- UPDATE


type Msg
    = CellClicked Int Int
    | GotTargetNumber Int
    | Tick
    | CellHovered Int Int
    | CellUnhovered
    | ClearWrongCell
    | ClearPenalty
    | PlayerNameChanged String
    | SaveScore
    | GotTimestamp Time.Posix


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotTargetNumber num ->
            ( { model | targetNumber = num }
            , Effect.none
            )

        Tick ->
            if model.isRunning && not model.gameComplete then
                ( { model | timer = model.timer + 1 }
                , Effect.none
                )

            else
                ( model, Effect.none )

        CellHovered row col ->
            ( { model | hoveredCell = Just ( row, col ) }
            , Effect.none
            )

        CellUnhovered ->
            ( { model | hoveredCell = Nothing }
            , Effect.none
            )

        ClearWrongCell ->
            ( { model | wrongCell = Nothing }
            , Effect.none
            )

        ClearPenalty ->
            ( { model | showPenalty = False }
            , Effect.none
            )

        PlayerNameChanged name ->
            ( { model | playerName = name }
            , Effect.none
            )

        SaveScore ->
            ( model
            , Effect.sendCmd (Task.perform GotTimestamp Time.now)
            )

        GotTimestamp posix ->
            ( { model | scoreSaved = True }
            , Effect.sendCmd
                (Lamdera.sendToBackend
                    (Bridge.SubmitScore "3x3" model.playerName model.timer model.mistakes (Time.posixToMillis posix))
                )
            )

        CellClicked row col ->
            if not model.isRunning || model.gameComplete then
                ( model, Effect.none )

            else
                let
                    product : Int
                    product =
                        row * col
                in
                if product == model.targetNumber then
                    let
                        newClickedCells : Set ( Int, Int )
                        newClickedCells =
                            Set.insert ( row, col ) model.clickedCells

                        isComplete : Bool
                        isComplete =
                            Set.size newClickedCells >= 9
                    in
                    ( { model
                        | clickedCells = newClickedCells
                        , gameComplete = isComplete
                        , isRunning = not isComplete
                      }
                    , if isComplete then
                        Effect.none

                      else
                        -- Always generate a new target after finding a correct cell
                        Effect.sendCmd (Random.generate GotTargetNumber (generateTarget newClickedCells model.targetNumber))
                    )

                else
                    ( { model
                        | mistakes = model.mistakes + 1
                        , timer = model.timer + 3
                        , wrongCell = Just ( row, col )
                        , showPenalty = True
                      }
                    , Effect.batch
                        [ Effect.sendCmd (Process.sleep 500 |> Task.perform (\_ -> ClearWrongCell))
                        , Effect.sendCmd (Process.sleep 500 |> Task.perform (\_ -> ClearPenalty))
                        ]
                    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.isRunning && not model.gameComplete then
        Time.every 1000 (\_ -> Tick)

    else
        Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Multiplication Practice"
    , body =
        [ div
            [ css
                [ Tw.min_h_screen
                , Tw.pt_16
                , Tw.pb_8
                ]
            ]
            [ div
                [ css
                    [ Tw.flex
                    , Tw.justify_center
                    , Tw.mt_4
                    , Tw.mb_4
                    ]
                ]
                [ a
                    [ href "/"
                    , css
                        [ Tw.px_4
                        , Tw.py_2
                        , Tw.border
                        , Tw.rounded
                        , Tw.font_bold
                        ]
                    ]
                    [ text "← Home" ]
                ]
            , div []
                [ div
                    [ css
                        [ Tw.flex
                        , Tw.justify_center
                        , Tw.mb_4
                        ]
                    ]
                    [ div
                        [ css
                            [ Tw.border_2
                            , Tw.border_solid
                            , Tw.rounded
                            , Tw.p_4
                            , Tw.text_center
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.text_sm
                                , Tw.mb_1
                                ]
                            ]
                            [ text "Find this number" ]
                        , div
                            [ css
                                [ Tw.text_4xl
                                , Tw.font_bold
                                ]
                            ]
                            [ text (String.fromInt model.targetNumber) ]
                        ]
                    ]
                , if model.gameComplete then
                    div
                        [ css
                            [ Tw.text_center
                            , Tw.mb_4
                            , Tw.p_4
                            , Tw.border
                            , Tw.rounded
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.text_2xl
                                , Tw.font_bold
                                ]
                            ]
                            [ text "Complete!" ]
                        , div
                            [ css
                                [ Tw.text_lg
                                , Tw.mb_4
                                ]
                            ]
                            [ text ("Time: " ++ formatTime model.timer ++ " | Mistakes: " ++ String.fromInt model.mistakes) ]
                        , if not model.scoreSaved then
                            div []
                                [ input
                                    [ type_ "text"
                                    , placeholder "Enter your name"
                                    , value model.playerName
                                    , onInput PlayerNameChanged
                                    , css
                                        [ Tw.border
                                        , Tw.rounded
                                        , Tw.px_4
                                        , Tw.py_2
                                        , Tw.mb_2
                                        , Tw.w_64
                                        ]
                                    , Html.Styled.Attributes.style "background-color" "white"
                                    , Html.Styled.Attributes.style "color" "black"
                                    ]
                                    []
                                , button
                                    [ onClick SaveScore
                                    , css
                                        [ Tw.px_6
                                        , Tw.py_2
                                        , Tw.border
                                        , Tw.rounded
                                        , Tw.font_bold
                                        , Tw.cursor_pointer
                                        , Tw.ml_2
                                        ]
                                    ]
                                    [ text "Save Score" ]
                                ]

                          else
                            div []
                                [ div [ css [ Tw.mb_4, Tw.font_bold ] ] [ text "Score saved!" ]
                                , viewLeaderboard shared.leaderboard3x3
                                ]
                        ]

                  else
                    text ""
                , viewGrid model
                , div
                    [ css
                        [ Tw.text_center
                        , Tw.mt_4
                        ]
                    ]
                    [ text ("Click cells where the multiplication equals " ++ String.fromInt model.targetNumber ++ ". Each mistake adds 3 seconds!") ]
                , div
                    [ css
                        [ Tw.text_center
                        , Tw.mt_4
                        , Tw.text_xl
                        , Tw.font_bold
                        ]
                    ]
                    [ text ("Progress: " ++ String.fromInt (Set.size model.clickedCells) ++ "/9 cells") ]
                , div
                    [ css
                        [ Tw.text_center
                        , Tw.mt_2
                        , Tw.text_xl
                        , Tw.font_bold
                        , Tw.flex
                        , Tw.items_center
                        , Tw.justify_center
                        , Tw.gap_2
                        ]
                    ]
                    [ text ("Time: " ++ formatTime model.timer)
                    , if model.showPenalty then
                        div
                            [ css
                                [ Tw.font_bold
                                ]
                            ]
                            [ text "+3" ]

                      else
                        text ""
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


viewGrid : Model -> Html.Styled.Html Msg
viewGrid model =
    div
        [ css
            [ Tw.flex
            , Tw.justify_center
            , Tw.mt_8
            ]
        ]
        [ div
            [ css
                [ Tw.relative
                ]
            ]
            [ -- Column headers and cells (centered)
              div
                [ css
                    [ Tw.flex
                    , Tw.flex_col
                    ]
                ]
                [ -- Column headers
                  div
                    [ css
                        [ Tw.flex
                        ]
                    ]
                    (List.map (viewColumnHeader model) (List.range 1 3))
                , -- Cell rows
                  div []
                    (List.map (viewRowCells model) (List.range 1 3))
                ]
            , -- Row headers positioned absolutely to the left
              div
                [ css
                    [ Tw.absolute
                    , Tw.top_0
                    , Tw.flex
                    , Tw.flex_col
                    ]
                , Html.Styled.Attributes.style "right" "100%"
                ]
                (div [ css [ Tw.w_12, Tw.h_12, Tw.m_1 ] ] [] :: List.map (viewRowHeader model) (List.range 1 3))
            ]
        ]


viewRowCells : Model -> Int -> Html.Styled.Html Msg
viewRowCells model rowNum =
    div
        [ css
            [ Tw.flex
            ]
        ]
        (List.map (viewCell model rowNum) (List.range 1 3))


viewColumnHeader : Model -> Int -> Html.Styled.Html Msg
viewColumnHeader model num =
    let
        isHighlighted : Bool
        isHighlighted =
            case model.hoveredCell of
                Just ( _, col ) ->
                    col == num

                Nothing ->
                    False
    in
    div
        [ css
            [ Tw.w_12
            , Tw.h_12
            , Tw.flex
            , Tw.items_center
            , Tw.justify_center
            , Tw.font_bold
            , Tw.m_1
            , Tw.rounded
            , if isHighlighted then
                Tw.border

              else
                Tw.border_0
            ]
        ]
        [ text (String.fromInt num) ]


viewRowHeader : Model -> Int -> Html.Styled.Html Msg
viewRowHeader model num =
    let
        isHighlighted : Bool
        isHighlighted =
            case model.hoveredCell of
                Just ( row, _ ) ->
                    row == num

                Nothing ->
                    False
    in
    div
        [ css
            [ Tw.w_12
            , Tw.h_12
            , Tw.flex
            , Tw.items_center
            , Tw.justify_center
            , Tw.font_bold
            , Tw.m_1
            , Tw.rounded
            , if isHighlighted then
                Tw.border

              else
                Tw.border_0
            ]
        ]
        [ text (String.fromInt num) ]


viewCell : Model -> Int -> Int -> Html.Styled.Html Msg
viewCell model row col =
    let
        isClicked : Bool
        isClicked =
            Set.member ( row, col ) model.clickedCells
    in
    div
        [ css
            [ Tw.w_12
            , Tw.h_12
            , if isClicked then
                Tw.border_0

              else
                Tw.border
            , Tw.flex
            , Tw.items_center
            , Tw.justify_center
            , Tw.m_1
            , Tw.cursor_pointer
            , if isClicked then
                Tw.opacity_30

              else
                Tw.opacity_100
            ]
        , onClick (CellClicked row col)
        , on "mouseenter" (Json.Decode.succeed (CellHovered row col))
        , on "mouseleave" (Json.Decode.succeed CellUnhovered)
        ]
        [ if isClicked then
            text "✓"

          else
            let
                isWrong : Bool
                isWrong =
                    model.wrongCell == Just ( row, col )
            in
            if isWrong then
                div
                    [ css
                        [ Tw.text_4xl
                        ]
                    ]
                    [ text "✗" ]

            else
                text ""
        ]


viewLeaderboard : List LeaderboardEntry -> Html.Styled.Html Msg
viewLeaderboard entries =
    div
        [ css
            [ Tw.mt_4
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
            [ text "Leaderboard" ]
        , div []
            (List.indexedMap viewLeaderboardEntry entries)
        ]


viewLeaderboardEntry : Int -> LeaderboardEntry -> Html.Styled.Html Msg
viewLeaderboardEntry index entry =
    div
        [ css
            [ Tw.flex
            , Tw.justify_between
            , Tw.p_2
            , Tw.border
            , Tw.rounded
            , Tw.mb_1
            ]
        ]
        [ div [] [ text (String.fromInt (index + 1) ++ ". " ++ entry.name) ]
        , div [] [ text (formatTime entry.time ++ " | " ++ String.fromInt entry.mistakes ++ " mistakes") ]
        ]
