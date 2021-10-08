module Skills.Main exposing (..)

import Browser exposing (Document)
import Common.Class as Class
import Common.Link as Link
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
    let
        entitled =
            Document "💡 My Skills"

        app items =
            [ div (class Class.appTop :: Skills.Class.bg)
                items
            ]
    in
    entitled <|
        app
            [ h1 Skills.Class.h1 [ text "What I Do" ]
            , div [ Skills.Class.row ]
                [ div [ Skills.Class.card ]
                    [ h2 [] [ text "Back End" ]
                    , p [] [ text "RESTful Microservices" ]
                    , p []
                        [ a [ Link.go, Skills.Class.pill ] [ text "Go" ]
                        , a [ Link.python, Skills.Class.pill ] [ text "Python" ]
                        ]
                    ]
                , div [ Skills.Class.card ]
                    [ h2 [] [ text "DevOps " ]
                    , p [] [ text "CI/CD, Server Management" ]
                    , p []
                        [ a [ Link.docker, Skills.Class.pill ] [ text "Docker" ]
                        , a [ Link.ansible, Skills.Class.pill ] [ text "Ansible" ]
                        ]
                    ]
                ]
            , div [ Skills.Class.row ]
                [ div [ Skills.Class.card ]
                    [ h2 [] [ text "Front End" ]
                    , p [] [ text "Web Apps" ]
                    , p []
                        [ a [ Link.elm, Skills.Class.pill ] [ text "Elm" ]
                        , a [ Link.vuejs, Skills.Class.pill ] [ text "Vue.js" ]
                        ]
                    ]
                , div [ Skills.Class.card ]
                    [ h2 [] [ text "Tutoring" ]
                    , p [] [ text "Zero-to-hero in programming" ]
                    , p []
                        [ a [ Link.go, Skills.Class.pill ] [ text "Go" ]
                        , a [ Link.python, Skills.Class.pill ] [ text "Python" ]
                        ]
                    ]
                ]
            ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
