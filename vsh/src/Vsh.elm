module Vsh exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


text : List String -> String -> Html msg
text classes message =
    span
        [ class <| String.join " " <| "vsh-text" :: classes ]
        [ Html.text message ]
