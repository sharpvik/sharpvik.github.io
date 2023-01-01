module Typer.Main exposing (..)

import Array exposing (Array)
import Browser exposing (Document)
import Browser.Events as Events
import Common.Class as Class
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Random
import Route exposing (Route(..))
import Task
import Time exposing (Posix)
import Typer.Class exposing (Color(..))
import Typer.Config
import Typer.Link
import Typer.Stopwatch as Stopwatch exposing (Stopwatch)
import Typer.Text as Text exposing (Text)



-- FLAGS


type alias Flags =
    ()



-- MODEL


type alias Model =
    { text : Text
    , stopwatch : Stopwatch
    , words : Words
    }


type Words
    = Loading
    | Failure
    | Words (Array String)



-- MSG


type Msg
    = Ignore
    | GotSymbol Char
    | GotStartTime Posix
    | GotEndTime Posix
    | Tick Posix
    | GotResetSignal
    | GotEraseSignal
    | GotWords (Result Http.Error String)
    | GotWordIndices (List Int)


type KeyboardEvent
    = Symbol Char
    | Tab
    | Enter
    | Backspace
    | Ctrl Char
    | Alt Char
    | Other



-- INIT


init : ( Model, Cmd Msg )
init =
    initModelWithWords Loading


initModelWithWords : Words -> ( Model, Cmd Msg )
initModelWithWords words =
    case words of
        Loading ->
            ( initModel, getWords )

        Failure ->
            ( { initModel
                | text = Text.fromString "Failed to load words..."
                , words = Failure
              }
            , Cmd.none
            )

        Words list ->
            ( { initModel | words = Words list }, getRandomWordIndices list )


initModel : Model
initModel =
    { text = Text.fromString "Loading words..."
    , stopwatch = Stopwatch.init
    , words = Loading
    }


getWords : Cmd Msg
getWords =
    Http.get
        { url = Typer.Link.words
        , expect = Http.expectString GotWords
        }



-- VIEW


view : Model -> Document Msg
view =
    let
        entitled =
            Document "⚡ Typer"

        app =
            div (Class.appCenter :: Typer.Class.bg) >> List.singleton
    in
    viewBody >> app >> entitled


viewBody : Model -> List (Html Msg)
viewBody model =
    let
        isTransparent =
            if Text.isUntouched model.text then
                []

            else
                [ Class.transparent ]

        header_ =
            [ h1 Typer.Class.h1 [ text "Type Fast" ]
            , h3 Typer.Class.h3 [ text "Physical keyboards only" ]
            ]

        footer_ =
            [ h3 Typer.Class.h3
                [ span [ Typer.Class.highlight ] [ text "tab ⇥" ]
                , text " to restart"
                ]
            , h3 Typer.Class.h3
                [ span [ Typer.Class.highlight ] [ text "❮ backspace" ]
                , text " to erase last symbol"
                ]
            ]

        txt =
            if Text.isComplete model.text then
                div []
                    [ p
                        [ Typer.Class.text, Typer.Class.colorToClass Black ]
                        [ text <| String.fromInt charsPerMinute ++ " chars/min." ]
                    , p
                        [ Typer.Class.text, Typer.Class.colorToClass Black ]
                        [ text <| String.fromInt model.text.correct ++ " correct" ]
                    , p
                        [ Typer.Class.text, Typer.Class.colorToClass Black ]
                        [ text <| String.fromInt (Text.errors model.text) ++ " incorrect" ]
                    , p
                        [ Typer.Class.text, Typer.Class.colorToClass Black ]
                        [ text <| String.fromFloat (Stopwatch.deltaInSeconds model.stopwatch) ++ " sec. in total" ]
                    ]

            else
                p [ Typer.Class.text ] <| Text.view model.text

        charsPerMinute =
            round <|
                toFloat model.text.correct
                    / toFloat model.stopwatch.delta
                    * 1000
                    * 60
    in
    [ header (Typer.Class.info :: isTransparent) header_
    , txt
    , footer (Typer.Class.info :: isTransparent) footer_
    ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSymbol char ->
            updateWithSymbol model char

        Ignore ->
            ( model, Cmd.none )

        GotStartTime time ->
            ( { model | stopwatch = Stopwatch.start model.stopwatch time }
            , Cmd.none
            )

        GotEndTime time ->
            ( { model | stopwatch = Stopwatch.end model.stopwatch time }
            , Cmd.none
            )

        Tick time ->
            ( { model | stopwatch = Stopwatch.update model.stopwatch time }
            , Cmd.none
            )

        GotResetSignal ->
            initModelWithWords model.words

        GotEraseSignal ->
            ( { model | text = Text.erase model.text }, Cmd.none )

        GotWords resp ->
            case resp of
                Ok body ->
                    let
                        words =
                            body |> String.lines |> Array.fromList
                    in
                    ( { model | words = Words words }
                    , getRandomWordIndices words
                    )

                Err _ ->
                    ( { model | words = Failure }, Cmd.none )

        GotWordIndices indices ->
            case model.words of
                Words words ->
                    ( { model | text = Text.fromWords words indices }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )


getRandomWordIndices : Array String -> Cmd Msg
getRandomWordIndices words =
    Random.generate GotWordIndices <|
        Random.list Typer.Config.wordsPerBatch <|
            Random.int 0 (Array.length words)


updateWithSymbol : Model -> Char -> ( Model, Cmd Msg )
updateWithSymbol model char =
    let
        newText =
            Text.update model.text char

        maybeRequestTime =
            if Text.isUntouched model.text then
                Task.perform GotStartTime Time.now

            else if
                Stopwatch.isRunning model.stopwatch
                    && Text.isComplete newText
            then
                Task.perform GotEndTime Time.now

            else
                Cmd.none
    in
    ( { model | text = newText }
    , maybeRequestTime
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        handleKeydownEvents =
            Events.onKeyDown keydownHandler
    in
    if Text.isUntouched model.text || Text.isComplete model.text then
        handleKeydownEvents

    else
        Sub.batch
            [ handleKeydownEvents
            , Time.every Typer.Config.millisBetweenTicks Tick
            ]


keydownHandler : Decode.Decoder Msg
keydownHandler =
    Decode.map toKeyDownMsg eventDecoder


toKeyDownMsg : KeyboardEvent -> Msg
toKeyDownMsg event =
    case event of
        Symbol letter ->
            GotSymbol letter

        Tab ->
            GotResetSignal

        Backspace ->
            GotEraseSignal

        _ ->
            Ignore


eventDecoder : Decode.Decoder KeyboardEvent
eventDecoder =
    Decode.map3
        eventConstructor
        (Decode.field "ctrlKey" Decode.bool)
        (Decode.field "altKey" Decode.bool)
        (Decode.field "key" Decode.string)


eventConstructor : Bool -> Bool -> String -> KeyboardEvent
eventConstructor ctrl alt key =
    if ctrl then
        specialKeyEvent Ctrl key

    else if alt then
        specialKeyEvent Alt key

    else
        case key of
            "Tab" ->
                Tab

            "Enter" ->
                Enter

            "Backspace" ->
                Backspace

            char ->
                specialKeyEvent Symbol char


specialKeyEvent : (Char -> KeyboardEvent) -> String -> KeyboardEvent
specialKeyEvent event key =
    if String.length key /= 1 then
        Other

    else
        case String.uncons key of
            Just ( char, _ ) ->
                event char

            Nothing ->
                Other
