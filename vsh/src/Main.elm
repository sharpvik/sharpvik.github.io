port module Main exposing (..)

import Browser
import Browser.Events as Events
import Command
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Vsh



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
    Command.version "version" []
        ++ [ text "\nEnter "
           , Vsh.text [ "vsh-green" ] "help"
           , text " to see available commands!\n\n"
           ]
        ++ prompt


prompt : List (Html Msg)
prompt =
    [ Vsh.text [ "vsh-yellow" ] "guest"
    , text " at "
    , Vsh.text [ "vsh-magenta" ] "sharpvik"
    , text "\n❯ "
    ]



-- VIEW


view : Model -> Html Msg
view model =
    vshDisplay <| model.display ++ [ text model.command ]


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
    Model (display ++ promptWithOffset) ""



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



-- PORTS


port scroll : () -> Cmd msg


port exit : () -> Cmd msg
