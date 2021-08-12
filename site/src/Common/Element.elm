module Common.Element exposing (..)

import Common.Class as Class
import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route(..))


navbar : Int -> Html msg
navbar active =
    let
        sections =
            [ ( AboutRoute, "👽" )
            , ( VshRoute, "💻" )
            ]

        mark id s =
            a
                ((if id == active then
                    [ class Class.navbarIconActive ]

                  else
                    []
                 )
                    ++ [ class Class.navbarIcon
                       , href <| Route.toString <| Tuple.first s
                       ]
                )
                [ text <| Tuple.second s ]

        result =
            List.indexedMap mark sections
    in
    nav [ class Class.navbar ] result


button_ : List (Attribute msg) -> String -> Html msg
button_ attrs txt =
    button (class Class.button :: attrs) [ text txt ]
