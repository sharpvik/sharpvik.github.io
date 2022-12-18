module Typer.Main exposing (..)

import Browser exposing (Document)
import Browser.Events as Events
import Common.Class as Class
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Route exposing (Route(..))
import Typer.Class
import Typer.Text as Text exposing (Text)



-- FLAGS


type alias Flags =
    ()



-- MODEL


type alias Model =
    Text



-- MSG


type Msg
    = Ignore
    | GotSymbol Char


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
    Text.fromString "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque id enim dui. Suspendisse id eros pretium, iaculis sem vel, venenatis ipsum. Nulla vel ullamcorper."



--VIEW


view : Model -> Document Msg
view model =
    let
        entitled =
            Document "⚡ Typer"

        app items =
            [ div (Class.appCenter :: Typer.Class.bg) items ]
    in
    entitled <|
        app
            [ p Typer.Class.text <| Text.view model
            ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSymbol letter ->
            ( Text.update model letter, Cmd.none )

        Ignore ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Events.onKeyDown keydownHandler


keydownHandler : Decode.Decoder Msg
keydownHandler =
    Decode.map toKeyDownMsg eventDecoder


toKeyDownMsg : KeyboardEvent -> Msg
toKeyDownMsg event =
    case event of
        Symbol letter ->
            GotSymbol letter

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
