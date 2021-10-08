module Skills.Class exposing (..)

import Common.Class as Class
import Html exposing (Attribute)
import Html.Attributes exposing (class)


bg : List (Attribute msg)
bg =
    [ class Class.bg, class "skills-bg" ]


h1 : List (Attribute msg)
h1 =
    [ class Class.h1, class "skills-h1" ]


h3 : List (Attribute msg)
h3 =
    [ class Class.h3, class "skills-h3" ]


row : Attribute msg
row =
    class "skills-row"


card : Attribute msg
card =
    class "skills-card"


pill : Attribute msg
pill =
    class "skills-pill"
