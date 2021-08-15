module Vsh.Class exposing (..)

import Common.Class as Class
import Html exposing (Attribute)
import Html.Attributes exposing (class)


h1 : List (Attribute msg)
h1 =
    [ class Class.h1, class "vsh-h1" ]


bg : List (Attribute msg)
bg =
    [ class Class.bg, class "vsh-bg" ]


window : String
window =
    "vsh-window"


topbar : String
topbar =
    "vsh-topbar"


close : String
close =
    "vsh-close"


textarea : String
textarea =
    "vsh-textarea"


text : String
text =
    "vsh-text"
