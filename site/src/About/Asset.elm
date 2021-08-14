module About.Asset exposing (github)

import Url.Builder exposing (absolute)


asset path =
    absolute ("assets" :: path) []


github =
    asset [ "github.svg" ]
