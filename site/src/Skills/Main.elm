module Skills.Main exposing (..)

import Browser exposing (Document)
import Common.Class as Class
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route exposing (Route(..))
import Skills.Class



-- FLAGS


type alias Flags =
    ()



-- MODEL


type Model
    = NoModel



-- MSG


type Msg
    = NoMsg



-- INIT


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    NoModel



--VIEW


view : Model -> Document Msg
view _ =
    {- <div>Icons made by <a href="https://www.flaticon.com/authors/pixel-perfect" title="Pixel perfect">Pixel perfect</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div> -}
    let
        entitled =
            Document "💡 My Skills"

        app items =
            [ div (class Class.appCenter :: Skills.Class.bg)
                items
            ]
    in
    entitled <|
        app
            [ h1 Skills.Class.h1 [ text "My Top Skills" ]
            , h3 Skills.Class.h3 [ text "... and some funky projects" ]
            ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
