module Route exposing (Route(..), fromUrl, toString)

import Url exposing (Protocol(..), Url)
import Url.Builder exposing (absolute)
import Url.Parser exposing (Parser, map, oneOf, parse, s, top)


type alias UrlParser a =
    Parser (Route -> a) a


type Route
    = AboutRoute
    | SkillsRoute
    | VshRoute


repr : Route -> String
repr route =
    case route of
        AboutRoute ->
            "about"

        SkillsRoute ->
            "skills"

        VshRoute ->
            "vsh"


routes : List Route
routes =
    let
        {- This check will prevent you from forgetting to update routes
           upon new Route creation.
        -}
        check route =
            case route of
                AboutRoute ->
                    ()

                SkillsRoute ->
                    ()

                VshRoute ->
                    ()
    in
    [ AboutRoute
    , SkillsRoute
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
