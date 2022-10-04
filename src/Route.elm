module Route exposing (Route(..), fromUrl, toString)

import Url exposing (Protocol(..), Url)
import Url.Builder exposing (absolute)
import Url.Parser exposing (Parser, map, oneOf, parse, s, top)


type alias UrlParser a =
    Parser (Route -> a) a


type Route
    = AboutRoute
    | VshRoute


repr : Route -> String
repr route =
    case route of
        AboutRoute ->
            "about"

        VshRoute ->
            "vsh"


routes : List Route
routes =
    [ AboutRoute
    , VshRoute
    ]



-- EXPOSED


fromUrl : Url -> Route
fromUrl url =
    Maybe.withDefault AboutRoute <|
        parse urlParser <|
            fake url


toString : Route -> String
toString route =
    "/#" ++ absolute [ repr route ] []



-- LOCAL


urlParser : UrlParser a
urlParser =
    let
        mapper route =
            map route <| s <| repr route
    in
    oneOf <|
        map AboutRoute top
            :: List.map mapper routes


fake : Url -> Url
fake path =
    { protocol = Https
    , host = "sharpvik.github.io"
    , port_ = Nothing
    , path = Maybe.withDefault "/#/about" path.fragment
    , query = Nothing
    , fragment = Nothing
    }
