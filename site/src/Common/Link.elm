module Common.Link exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (href)


mailto : Attribute msg
mailto =
    href "mailto:sharp.vik@gmail.com"


github : Attribute msg
github =
    href "https://github.com/sharpvik"


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


docker =
    href "https://www.docker.com"


ansible =
    href "https://www.ansible.com/"
