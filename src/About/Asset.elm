module About.Asset exposing (cv, github)

import Url.Builder exposing (absolute)


asset : List String -> String
asset path =
    absolute ("assets" :: path) []


github : String
github =
    asset [ "github.svg" ]


cv : String
cv =
    asset [ "Resume.pdf" ]
