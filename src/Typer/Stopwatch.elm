module Typer.Stopwatch exposing (..)

import Maybe.Extra as Maybex
import Time exposing (Posix(..))


type alias Stopwatch =
    { start : Maybe Posix
    , end : Maybe Posix
    , delta : Int -- in millis
    }



-- INIT


init : Stopwatch
init =
    { start = Nothing
    , end = Nothing
    , delta = 0
    }



-- UPDATE


start : Stopwatch -> Posix -> Stopwatch
start stopwatch time =
    { stopwatch | start = Just time }


end : Stopwatch -> Posix -> Stopwatch
end stopwatch time =
    case stopwatch.start of
        Just from ->
            { stopwatch | end = Just time, delta = diff from time }

        _ ->
            stopwatch


update : Stopwatch -> Posix -> Stopwatch
update stopwatch time =
    case ( stopwatch.start, stopwatch.end ) of
        ( Just from, Nothing ) ->
            { stopwatch | delta = diff from time }

        _ ->
            stopwatch



-- QUERY


isRunning : Stopwatch -> Bool
isRunning stopwatch =
    Maybex.isNothing stopwatch.end


deltaInSeconds : Stopwatch -> Float
deltaInSeconds stopwatch =
    toFloat stopwatch.delta / 1000



-- UTIL


diff : Posix -> Posix -> Int
diff a b =
    Time.posixToMillis b - Time.posixToMillis a
