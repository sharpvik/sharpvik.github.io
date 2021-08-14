module Skills.Asset exposing (github, gmail)

import Url.Builder exposing (absolute)


asset path =
    absolute ("assets" :: path) []


github =
    asset [ "github.svg" ]


gmail =
    asset [ "gmail.svg" ]
