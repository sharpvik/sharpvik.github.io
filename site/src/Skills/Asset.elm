module Skills.Asset exposing (github, gmail)

import Url.Builder exposing (absolute)


asset : List String -> String
asset path =
    absolute ("assets" :: path) []


github : String
github =
    asset [ "github.svg" ]


gmail : String
gmail =
    asset [ "gmail.svg" ]
