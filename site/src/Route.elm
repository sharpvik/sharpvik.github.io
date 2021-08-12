module Route exposing (Route(..), fromUrl, toString)

import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, fragment, parse)


type alias UrlParser a =
    Parser (Route -> a) a


type Route
    = AboutRoute
    | VshRoute


urlParser : UrlParser a
urlParser =
    let
        foo maybe =
            let
                must =
                    Maybe.withDefault "/about" maybe
            in
            if String.startsWith "/about" must then
                AboutRoute

            else if String.startsWith "/vsh" must then
                VshRoute

            else
                AboutRoute
    in
    fragment foo


fromUrl : Url -> Route
fromUrl url =
    Maybe.withDefault AboutRoute <|
        Debug.log "route" (parse urlParser url)


toString : Route -> String
toString route =
    let
        p =
            (++) "/#/"
    in
    case route of
        AboutRoute ->
            p "about"

        VshRoute ->
            p "vsh"
