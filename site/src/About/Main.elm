module About.Main exposing (..)

import Browser exposing (Document)
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
    { title = "About Me"
    , body =
        [ h1 [] [ text "About Page" ]
        , a [ href <| Route.toString VshRoute ] [ text "Terminal" ]
        ]
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
