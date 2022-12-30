module Typer.Class exposing (..)

import Common.Class as Class
import Html exposing (Attribute)
import Html.Attributes exposing (class)


bg : List (Attribute msg)
bg =
    [ Class.bg, class "typer-bg" ]



-- TEXT


type Color
    = Grey
    | Black
    | Red


colorToClass : Color -> Attribute msg
colorToClass color =
    case color of
        Grey ->
            class "typer-text-grey"

        Black ->
            class "typer-text-black"

        Red ->
            class "typer-text-red"


text : Attribute msg
text =
    class "typer-text"
