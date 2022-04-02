module Common.Link exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (href)


email : String
email =
    "sharp.vik@gmail.com"


mailto : String
mailto =
    "mailto:" ++ email


linkedin : String
linkedin =
    "https://www.linkedin.com/in/sharpvik"


github : String
github =
    "https://github.com/sharpvik"


repo : String
repo =
    "https://github.com/sharpvik/sharpvik.github.io"



-- EXTERNAL


go : Attribute msg
go =
    href "https://golang.org"


python : Attribute msg
python =
    href "https://www.python.org/about"


elm : Attribute msg
elm =
    href "https://elm-lang.org"


vuejs : Attribute msg
vuejs =
    href "https://vuejs.org"


docker : Attribute msg
docker =
    href "https://www.docker.com"


ansible : Attribute msg
ansible =
    href "https://www.ansible.com/"


attr : String -> Attribute msg
attr =
    href
