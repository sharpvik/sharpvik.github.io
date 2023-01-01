module Typer.Text exposing (..)

import Array exposing (Array)
import Flip exposing (flip)
import Html exposing (Html, span, text)
import Typer.Class as Class exposing (Color(..))



-- TEXT


type alias Text =
    { pointer : Int
    , correct : Int
    , symbols : Array Symbol
    }



-- CONSTRUCTORS


fromWords : Array String -> List Int -> Text
fromWords words =
    let
        pick =
            flip Array.get words >> Maybe.withDefault "default"
    in
    List.map pick >> String.join " " >> fromString


fromString : String -> Text
fromString =
    String.toList
        >> List.map Unknown
        >> Array.fromList
        >> Text 0 0



-- QUERY


symbols : Text -> List Symbol
symbols txt =
    Array.toList txt.symbols


expectedChar : Text -> Maybe Char
expectedChar txt =
    Array.get txt.pointer txt.symbols |> Maybe.map symbolToChar


isUntouched : Text -> Bool
isUntouched txt =
    txt.pointer == 0


isComplete : Text -> Bool
isComplete txt =
    txt.pointer >= Array.length txt.symbols


errors : Text -> Int
errors txt =
    Array.length txt.symbols - txt.correct



-- VIEW


view : Text -> List (Html msg)
view =
    List.map viewSymbol << symbols


viewSymbol : Symbol -> Html msg
viewSymbol symbol =
    let
        colorClass =
            symbol |> symbolToColor |> Class.colorToClass

        symbolBody =
            text (symbol |> symbolToChar |> String.fromChar)
    in
    span [ colorClass ] [ symbolBody ]



-- UPDATE


update : Text -> Char -> Text
update txt char =
    case expectedChar txt of
        Nothing ->
            txt

        Just expect ->
            updateWithRatedSymbol txt expect (expect == char)


updateWithRatedSymbol : Text -> Char -> Bool -> Text
updateWithRatedSymbol txt expect isGood =
    { pointer = txt.pointer + 1
    , symbols = Array.set txt.pointer (symbolFromBool isGood expect) txt.symbols
    , correct = txt.correct + boolToInt isGood
    }


erase : Text -> Text
erase txt =
    let
        pointerLeftShift =
            txt.pointer - 1

        lastEnteredSymbol =
            Array.get pointerLeftShift txt.symbols
                |> Maybe.withDefault (Unknown '?')

        lastEnteredSymbolAsUnkown =
            lastEnteredSymbol |> symbolToUnknown
    in
    if isUntouched txt || isComplete txt then
        txt

    else
        { pointer = pointerLeftShift
        , correct = txt.correct - (boolToInt <| symbolIsGood lastEnteredSymbol)
        , symbols = Array.set pointerLeftShift lastEnteredSymbolAsUnkown txt.symbols
        }


boolToInt bool =
    if bool then
        1

    else
        0



-- SYMBOL


type Symbol
    = Unknown Char
    | Good Char
    | Bad Char


symbolFromBool : Bool -> Char -> Symbol
symbolFromBool isGood =
    if isGood then
        Good

    else
        Bad


symbolToChar : Symbol -> Char
symbolToChar symbol =
    case symbol of
        Unknown char ->
            char

        Good char ->
            char

        Bad char ->
            char


symbolToColor : Symbol -> Color
symbolToColor symbol =
    case symbol of
        Unknown _ ->
            Grey

        Good _ ->
            Black

        Bad _ ->
            Red


symbolToUnknown : Symbol -> Symbol
symbolToUnknown =
    symbolToChar >> Unknown


symbolIsGood : Symbol -> Bool
symbolIsGood symbol =
    case symbol of
        Good _ ->
            True

        _ ->
            False
