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
            , ( VshRoute, "⌨️" )
            ]

        activated id =
            if id == active then
                [ Class.navbarIconActive ]

            else
                []

        mark id s =
            a
                (activated id
                    ++ [ Class.navbarIcon
                       , href <| Route.toString <| Tuple.first s
                       ]
                )
                [ text <| Tuple.second s ]

        result =
            List.indexedMap mark sections
    in
    nav [ Class.navbar ] result


button_ :
    (List (Attribute msg)
     -> List (Html msg)
     -> Html msg
    )
    -> List (Attribute msg)
    -> String
    -> Html msg
button_ elem attrs txt =
    elem (Class.button :: attrs) [ text txt ]


textCenter : List (Html msg) -> Html msg
textCenter =
    div [ style "text-align" "center" ]
