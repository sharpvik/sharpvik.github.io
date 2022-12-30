module Typer.Main exposing (..)

import Browser exposing (Document)
import Browser.Events as Events
import Common.Class as Class
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Route exposing (Route(..))
import Task
import Time exposing (Posix)
import Typer.Class exposing (Color(..))
import Typer.Stopwatch as Stopwatch exposing (Stopwatch)
import Typer.Text as Text exposing (Text)



-- FLAGS


type alias Flags =
    ()



-- MODEL


type alias Model =
    { text : Text
    , stopwatch : Stopwatch
    }



-- MSG


type Msg
    = Ignore
    | GotSymbol Char
    | GotStartTime Posix
    | GotEndTime Posix
    | Tick Posix
    | GotResetSignal


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
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { text = Text.fromString "Lorem ipsum dolor sit amet."
    , stopwatch = Stopwatch.init
    }



--VIEW


view : Model -> Document Msg
view model =
    let
        entitled =
            Document "⚡ Typer"

        app items =
            [ div (Class.appCenter :: Typer.Class.bg) items ]

        charsPerMinute =
            round <|
                toFloat model.text.correct
                    / toFloat model.stopwatch.delta
                    * 1000
                    * 60

        body =
            if Text.isComplete model.text then
                [ div []
                    [ p [ Typer.Class.text, Typer.Class.colorToClass Black ]
                        [ text <| String.fromInt charsPerMinute ++ " chars/min." ]
                    ]
                ]

            else
                [ p [ Typer.Class.text ] <| Text.view model.text
                ]
    in
    body |> app |> entitled



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
            init


updateWithSymbol : Model -> Char -> ( Model, Cmd Msg )
updateWithSymbol model char =
    let
        newText =
            Text.update model.text char

        maybeRequestTime =
            if Text.isUntouched model.text then
                Task.perform GotStartTime Time.now

            else if Stopwatch.isRunning model.stopwatch && Text.isComplete newText then
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
        Sub.batch [ handleKeydownEvents, Time.every 10 Tick ]


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
