module Route exposing (Route(..), fromUrl, toString)

import Url exposing (Protocol(..), Url)
import Url.Builder exposing (absolute)
import Url.Parser exposing (Parser, map, oneOf, parse, s, top)


type alias UrlParser a =
    Parser (Route -> a) a


type Route
    = AboutRoute
    | VshRoute


fromUrl : Url -> Route
fromUrl url =
    Maybe.withDefault AboutRoute <|
        Debug.log "route" <|
            parse urlParser <|
                fake url


toString : Route -> String
toString route =
    let
        p =
            (++) "/#"
    in
    case route of
        AboutRoute ->
            absolute [ "about" ] [] |> p

        VshRoute ->
            absolute [ "vsh" ] [] |> p


urlParser : UrlParser a
urlParser =
    oneOf
        [ map AboutRoute top
        , map AboutRoute <| s "about"
        , map VshRoute <| s "vsh"
        ]


fake : Url -> Url
fake path =
    { protocol = Http
    , host = "example.com"
    , port_ = Nothing
    , path = Maybe.withDefault "/about" path.fragment
    , query = Nothing
    , fragment = Nothing
    }
