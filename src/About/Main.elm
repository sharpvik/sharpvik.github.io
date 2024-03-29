module About.Main exposing (..)

import About.Asset as Asset
import About.Class
import Browser exposing (Document)
import Common.Class as Class
import Common.Element as Element
import Common.Link as Link
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
            [ div (Class.appCenter :: About.Class.bg) <| general items ]

        general =
            (++)
                [ h1 About.Class.h1 [ text "Hey, I'm Viktor!" ]
                , h3 About.Class.h3
                    [ text "🔥 Blog post writer "
                    , a
                        [ Class.link, href "https://t.me/recreational_computation" ]
                        [ text "@rc" ]
                    ]
                , h3 About.Class.h3
                    [ text "👨\u{200D}💼 Co-founder "
                    , a [ Class.link, href "https://aquilex.org/" ]
                        [ text "@aquilex" ]
                    ]
                , h3 About.Class.h3 [ text "💻 Senior Software Engineer" ]
                , h3 About.Class.h3 [ text "🎓 University of Southampton" ]
                ]
    in
    entitled <|
        app
            [ a
                [ Link.attr Link.github
                , target "_blank"
                , About.Class.github
                ]
                [ img [ src Asset.github ] [] ]
            , Element.textCenter
                [ Element.button_ a
                    ([ Link.attr Link.mailto
                     , target "_blank"
                     ]
                        ++ About.Class.button
                    )
                    "EMAIL ME!"
                , Element.button_ a
                    ([ Link.attr Asset.cv
                     , target "_blank"
                     ]
                        ++ About.Class.button
                    )
                    "READ MY CV"
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
