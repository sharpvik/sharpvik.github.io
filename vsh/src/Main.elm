port module Main exposing (..)

import Browser
import Browser.Events as Events
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode



-- MAIN


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- FLAGS


type alias Flags =
    ()



-- MODEL


type alias Model =
    { display : List (Html Msg)
    , command : String
    }



-- MSG


type Msg
    = KeyDown KeyDownType
    | Exit


type KeyDownType
    = Character String
    | Enter
    | Backspace
    | Ignore



-- INIT


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { display = greeting
    , command = ""
    }


greeting : List (Html Msg)
greeting =
    [ text "vsh v0.1.0 by Viktor A. Rozenko Voitenko <sharp.vik@gmail.com>\n"
    , text "Enter "
    , vshText [ "vsh-green" ] "help"
    , text " to see available commands!"
    ]
        ++ prompt


prompt : List (Html Msg)
prompt =
    [ vshText [ "vsh-yellow" ] "\n\nguest"
    , vshText [] " at "
    , vshText [ "vsh-magenta" ] "sharpvik"
    , vshText [] "\n❯ "
    ]


vshText : List String -> String -> Html Msg
vshText classes message =
    span
        [ class <| String.join " " <| "vsh-text" :: classes ]
        [ text message ]



-- VIEW


view : Model -> Html Msg
view model =
    vshDisplay <| model.display ++ [ vshText [] model.command ]


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
        KeyDown (Character char) ->
            ( { model | command = command ++ char }, Cmd.none )

        KeyDown Enter ->
            ( updateOnCommand model command
            , scroll ()
            )

        KeyDown Backspace ->
            ( { model | command = String.dropRight 1 command }
            , Cmd.none
            )

        KeyDown Ignore ->
            ( model, Cmd.none )

        Exit ->
            ( updateOnCommand model "exit", Cmd.batch [ exit (), scroll () ] )


updateOnCommand : Model -> String -> Model
updateOnCommand model command =
    let
        output =
            vshText [] <|
                case List.head <| String.words command of
                    Nothing ->
                        "weird command: '" ++ command ++ "'"

                    Just cmd ->
                        executeCommand cmd

        display =
            model.display ++ [ vshText [] (command ++ "\n"), output ] ++ prompt
    in
    Model display ""


executeCommand : String -> String
executeCommand command =
    case command of
        "whoami" ->
            commandWhoAmI

        "touch" ->
            commandTouch

        "job" ->
            commandJob

        "help" ->
            commandHelp

        "exit" ->
            "Shutting down..."

        _ ->
            "unknown command: '" ++ command ++ "'"


commandWhoAmI : String
commandWhoAmI =
    """Hey, my name is Viktor! 
I study Computer Science in the University of Southampton.

At work, I currently specialise in high-throughput microservices. I build them
with Go and Python. However, I also enjoy playing around with Haskell, Elm,
Vue.js, and Rust.

In my spare time, I dabble in compiler design and implementation. I love
creating new programming languages! Given a chance, I'd like to do some
professional research into deterministic garbage collection within pure
functional languages."""


commandTouch : String
commandTouch =
    """Ways to get in touch:
    
    email:      sharp.vik@gmail.com
    github:     https://github.com/sharpvik
    linkedin:   https://www.linkedin.com/in/sharpvik"""


commandJob : String
commandJob =
    """Before you offer me a job, I'd like to tell you a few things:

    1. I am a uni student; during my term time, I can only work 20hr./week
    2. Nevertheless, full-time work is possible during the term breaks
    3. I specialise in cloud services and web development, but I'm open to
       interesting offers
       
Use the 'touch' command to get in touch."""


commandHelp : String
commandHelp =
    """Available commands:

    whoami  -- a bit about myself
    touch   -- ways to get in touch (my contact info)
    job     -- hire me if you're really impressed

    help    -- display this message again"""



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Events.onKeyDown keydownHandler


keydownHandler : Decode.Decoder Msg
keydownHandler =
    Decode.map toKeyDownMsg (Decode.field "key" Decode.string)


toKeyDownMsg : String -> Msg
toKeyDownMsg string =
    KeyDown <|
        case string of
            "Enter" ->
                Enter

            "Backspace" ->
                Backspace

            "Tab" ->
                Character "  "

            _ ->
                if String.length string == 1 then
                    Character string

                else
                    Ignore


port scroll : () -> Cmd msg


port exit : () -> Cmd msg
