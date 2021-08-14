module Vsh.Class exposing (..)

import Common.Class as Class
import Html exposing (Attribute)
import Html.Attributes exposing (class)


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
