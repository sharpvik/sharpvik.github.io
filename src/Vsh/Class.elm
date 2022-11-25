module Vsh.Class exposing (..)

import Common.Class as Class
import Html exposing (Attribute)
import Html.Attributes exposing (class)


h1 : List (Attribute msg)
h1 =
    [ Class.h1, class "vsh-h1" ]


bg : List (Attribute msg)
bg =
    [ Class.bg, class "vsh-bg" ]


window : Attribute msg
window =
    class "vsh-window"


topbar : Attribute msg
topbar =
    class "vsh-topbar"


close : Attribute msg
close =
    class "vsh-close"


textarea : Attribute msg
textarea =
    class "vsh-textarea"


text : Attribute msg
text =
    class "vsh-text"
