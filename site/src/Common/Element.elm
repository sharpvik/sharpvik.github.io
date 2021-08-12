module Common.Element exposing (..)

import Common.Class as Class
import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route(..))


navbar : Html msg
navbar =
    nav [ class Class.navbar ]
        [ a [ class Class.navbarIcon, href <| Route.toString AboutRoute ]
            [ text "👽" ]
        , a [ class Class.navbarIcon, href <| Route.toString VshRoute ]
            [ text "💻" ]
        ]
