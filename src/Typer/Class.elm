module Typer.Class exposing (..)

import Common.Class as Class
import Html exposing (Attribute)
import Html.Attributes exposing (class)


bg : List (Attribute msg)
bg =
    [ Class.bg, class "typer-bg" ]


h1 : List (Attribute msg)
h1 =
    [ Class.h1, class "typer-h1" ]


h3 : List (Attribute msg)
h3 =
    [ Class.h3, class "typer-h3" ]


url : Attribute msg
url =
    class "typer-url"


highlight : Attribute msg
highlight =
    class "typer-highlight"


info : Attribute msg
info =
    class "typer-info"



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
