module Common.Class exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (class)



-- APP


appCenter : Attribute msg
appCenter =
    class "app-center"


appTop : Attribute msg
appTop =
    class "app-top"



-- ELEMENTS


bg : Attribute msg
bg =
    class "bg"


h1 : Attribute msg
h1 =
    class "h1"


h3 : Attribute msg
h3 =
    class "h3"


link : Attribute msg
link =
    class "link"



-- BUTTON


button : Attribute msg
button =
    class "button"



-- NAVBAR


navbar : Attribute msg
navbar =
    class "navbar"


navbarIcon : Attribute msg
navbarIcon =
    class "navbar-icon"


navbarIconActive : Attribute msg
navbarIconActive =
    class "navbar-icon-active"
