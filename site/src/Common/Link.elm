module Common.Link exposing (..)

import Html.Attributes exposing (href)
import Url.Builder exposing (crossOrigin)


linkedin =
    href <| crossOrigin "https://linkedin.com" [ "in", "sharpvik" ] []
