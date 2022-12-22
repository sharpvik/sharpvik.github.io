module Typer.Text exposing (..)

import Array exposing (Array)
import Html exposing (Html, span, text)
import Html.Attributes exposing (style)



-- TEXT


type alias Text =
    { pointer : Int
    , symbols : Array Symbol
    }



-- CONSTRUCTORS


fromString : String -> Text
fromString =
    String.toList
        >> List.map Unknown
        >> Array.fromList
        >> Text 0



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



-- VIEW


view : Text -> List (Html msg)
view =
    List.map viewSymbol << symbols


viewSymbol : Symbol -> Html msg
viewSymbol symbol =
    case symbol of
        Unknown char ->
            span [ style "color" "grey" ] [ text (String.fromChar char) ]

        Good char ->
            span [ style "color" "green" ] [ text (String.fromChar char) ]

        Bad char ->
            span
                [ style "color" "red"
                , style "background-color" "pink"
                ]
                [ text (String.fromChar char) ]



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
    }



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
