module About.Main exposing (..)

import About.Class
import Browser exposing (Document)
import Common.Class as Class
import Common.Element as Element
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route exposing (Route(..))



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
    let
        entitled =
            Document "👽 About Me"

        app items =
            [ div [ class Class.appCenter, class About.Class.bg ] <|
                general items
            ]

        general =
            (++)
                [ h1 [ class About.Class.h1 ] [ text "Hey, I'm Viktor!" ]
                , h3 [ class About.Class.h3 ] [ text "💻 Full Stack Web Developer" ]
                , h3 [ class About.Class.h3 ] [ text "🎓 University of Southampton" ]
                ]
    in
    entitled <|
        app
            [ Element.button_ a
                [ class About.Class.button, href <| Route.toString VshRoute ]
                "HIRE ME!"
            ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
