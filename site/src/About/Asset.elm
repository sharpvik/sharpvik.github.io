module About.Asset exposing (github)

import Url.Builder exposing (absolute)


asset : List String -> String
asset path =
    absolute ("assets" :: path) []


github : String
github =
    asset [ "github.svg" ]
