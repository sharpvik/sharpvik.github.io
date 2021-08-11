port module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Events as Events
import Browser.Navigation as Nav
import Command
import History exposing (History)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Url exposing (Url)
import Vsh



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = LinkChanged
        }



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
    | LinkClicked UrlRequest
    | LinkChanged Url


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


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { display = greeting
    , command = ""
    , history = History.empty
    }


greeting : List (Html Msg)
greeting =
    Command.version "version" []
        ++ [ text "\nEnter "
           , Vsh.ctext Vsh.Green "help"
           , text " to see available commands!\n\n"
           ]
        ++ prompt


prompt : List (Html Msg)
prompt =
    [ Vsh.ctext Vsh.Yellow "guest"
    , text " at "
    , Vsh.ctext Vsh.Magenta "sharpvik"
    , text "\n❯ "
    ]



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Viktor = 💻 ☕ ❤️"
    , body = [ vshDisplay <| model.display ++ [ text model.command ] ]
    }


vshDisplay : List (Html Msg) -> Html Msg
vshDisplay display =
    div
        [ class "vsh-window"
        ]
        [ header
            [ class "vsh-topbar vsh-width"
            ]
            [ p []
                [ text "vsh shell" ]
            , button
                [ class "vsh-close"
                , onClick Exit
                ]
                []
            ]
        , pre
            [ class "vsh-textarea vsh-width-fill" ]
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
            ( maybeLookupHistory History.prev model, Cmd.none )

        KeyDown ArrowDown ->
            ( maybeLookupHistory History.next model, Cmd.none )

        Clear ->
            ( updateOnCommand model "clear", Cmd.none )

        Exit ->
            ( updateOnCommand model "exit", Cmd.batch [ exit (), scroll () ] )

        Ignore ->
            ( model, Cmd.none )

        KeyDown (Ctrl _) ->
            ( model, Cmd.none )

        KeyDown (Alt _) ->
            ( model, Cmd.none )

        KeyDown Other ->
            ( model, Cmd.none )

        LinkClicked _ ->
            ( model, Cmd.none )

        LinkChanged _ ->
            ( model, Cmd.none )


maybeLookupHistory : (History -> Int) -> Model -> Model
maybeLookupHistory getptr model =
    case History.lookup getptr model.history of
        Nothing ->
            model

        Just ( command, history ) ->
            { model | command = command, history = history }


updateOnCommand : Model -> String -> Model
updateOnCommand model command =
    let
        display =
            Command.exec command <|
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
    , history = History.update command model.history
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


port exit : () -> Cmd msg
