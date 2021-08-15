port module Vsh.Main exposing (..)

import Browser exposing (Document)
import Browser.Events as Events
import Browser.Navigation as Nav
import Common.Class as Class
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Route exposing (Route(..))
import Vsh.Class
import Vsh.Command
import Vsh.History exposing (History)
import Vsh.Text exposing (Color(..), ctext)



-- FLAGS


type alias Flags =
    ()



-- MODEL


type alias Model =
    { display : List (Html Msg)
    , command : String
    , history : History
    }



-- MSG


type Msg
    = KeyDown KeyboardEvent
    | Clear
    | Exit
    | Ignore


type KeyboardEvent
    = Symbol Char
    | Tab
    | Enter
    | Backspace
    | ArrowUp
    | ArrowDown
    | Ctrl Char
    | Alt Char
    | Other



-- INIT


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { display = greeting
    , command = ""
    , history = Vsh.History.empty
    }


greeting : List (Html Msg)
greeting =
    Vsh.Command.version "version" []
        ++ [ text "\nEnter "
           , ctext Green "help"
           , text " to see available commands!\n"
           , ctext Yellow "VSH does not support mobile devices.\n\n"
           ]
        ++ prompt


prompt : List (Html Msg)
prompt =
    [ ctext Yellow "guest"
    , text " at "
    , ctext Magenta "sharpvik"
    , text "\n❯ "
    ]



-- VIEW


view : Model -> Document Msg
view model =
    { title = "💻 ️VSH Shell"
    , body =
        [ div (class Class.appTop :: Vsh.Class.bg)
            [ h1 Vsh.Class.h1 [ text "Hack Me 🤓" ]
            , vshDisplay <| model.display ++ [ text model.command ]
            ]
        ]
    }


vshDisplay : List (Html Msg) -> Html Msg
vshDisplay display =
    div
        [ class Vsh.Class.window
        ]
        [ header
            [ class Vsh.Class.topbar ]
            [ p []
                [ text "vsh shell" ]
            , a
                [ class Vsh.Class.close
                , href <| Route.toString AboutRoute
                ]
                []
            ]
        , pre
            [ class Vsh.Class.textarea ]
            (display ++ [ text "█" ])
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updateOnKeydown msg model model.command


updateOnKeydown : Msg -> Model -> String -> ( Model, Cmd Msg )
updateOnKeydown msg model command =
    case msg of
        KeyDown (Symbol char) ->
            ( { model | command = command ++ String.fromChar char }, Cmd.none )

        KeyDown Tab ->
            ( { model | command = command ++ "  " }, Cmd.none )

        KeyDown Enter ->
            ( updateOnCommand model command, scroll () )

        KeyDown Backspace ->
            ( { model | command = String.dropRight 1 command }, Cmd.none )

        KeyDown ArrowUp ->
            ( maybeLookupHistory Vsh.History.prev model, Cmd.none )

        KeyDown ArrowDown ->
            ( maybeLookupHistory Vsh.History.next model, Cmd.none )

        Clear ->
            ( updateOnCommand model "clear", Cmd.none )

        Exit ->
            ( model
            , Nav.load <| Route.toString AboutRoute
            )

        _ ->
            ( model, Cmd.none )


maybeLookupHistory : (History -> Int) -> Model -> Model
maybeLookupHistory getptr model =
    case Vsh.History.lookup getptr model.history of
        Nothing ->
            model

        Just ( command, history ) ->
            { model | command = command, history = history }


updateOnCommand : Model -> String -> Model
updateOnCommand model command =
    let
        display =
            Vsh.Command.exec command <|
                model.display
                    ++ [ text (command ++ "\n") ]

        promptWithOffset =
            (text <|
                if List.isEmpty display then
                    ""

                else
                    "\n\n"
            )
                :: prompt
    in
    { display = display ++ promptWithOffset
    , command = ""
    , history = Vsh.History.update command model.history
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Events.onKeyDown keydownHandler


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

            "ArrowUp" ->
                ArrowUp

            "ArrowDown" ->
                ArrowDown

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


keydownHandler : Decode.Decoder Msg
keydownHandler =
    Decode.map toKeyDownMsg eventDecoder


toKeyDownMsg : KeyboardEvent -> Msg
toKeyDownMsg event =
    case event of
        Ctrl ';' ->
            Clear

        Ctrl 'e' ->
            Exit

        Other ->
            Ignore

        e ->
            KeyDown e



-- PORTS


port scroll : () -> Cmd msg
