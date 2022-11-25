module About.Class exposing (..)

import Common.Class as Class
import Html exposing (Attribute)
import Html.Attributes exposing (class)


bg : List (Attribute msg)
bg =
    [ Class.bg, class "about-bg" ]


h1 : List (Attribute msg)
h1 =
    [ Class.h1, class "about-h1" ]


h3 : List (Attribute msg)
h3 =
    [ Class.h3, class "about-h3" ]


button : List (Attribute msg)
button =
    [ Class.button, class "about-button" ]


github : Attribute msg
github =
    class "about-github"
