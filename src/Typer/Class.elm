module Typer.Class exposing (..)

import Common.Class as Class
import Html exposing (Attribute)
import Html.Attributes exposing (class)


bg : List (Attribute msg)
bg =
    [ Class.bg, class "about-bg" ]


text : List (Attribute msg)
text =
    [ class "typer-text" ]
