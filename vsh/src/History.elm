module History exposing (..)

import Array exposing (Array)


type alias History =
    { history : Array String, ptr : Int }


lookup : (History -> Int) -> History -> Maybe ( String, History )
lookup getptr history =
    let
        ptr =
            getptr history
    in
    if Array.isEmpty history.history then
        Nothing

    else
        Just <|
            ( Maybe.withDefault "" <| Array.get ptr history.history
            , { history | ptr = ptr }
            )


next : History -> Int
next history =
    if Array.length history.history > history.ptr + 1 then
        history.ptr + 1

    else
        0


prev : History -> Int
prev history =
    if history.ptr == 0 then
        Array.length history.history - 1

    else
        history.ptr - 1
