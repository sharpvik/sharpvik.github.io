module Vsh.Text exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


ctext : Color -> String -> Html msg
ctext color message =
    span
        [ class <| "vsh-text " ++ colorToClass color ]
        [ Html.text message ]


type Color
    = Yellow
    | Green
    | Magenta


colorToClass : Color -> String
colorToClass c =
    "vsh-"
        ++ (case c of
                Yellow ->
                    "yellow"

                Green ->
                    "green"

                Magenta ->
                    "magenta"
           )
