module Common.Link exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (href)
import Url.Builder exposing (crossOrigin)


linkedin : Attribute msg
linkedin =
    href <| crossOrigin "https://linkedin.com" [ "in", "sharpvik" ] []
