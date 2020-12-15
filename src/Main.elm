module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput) 

main =
  Browser.sandbox { init = init, update = update, view = view }

type alias Model =
  { items : List String 
  , item : String
  }

init : Model
init =
  { items = [ "Apple", "Banana", "Carrot" ]
  , item = ""
  }

type Msg
  = Update String
  | Add String
  | Remove String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Update text -> 
      { model 
      | item = text 
      }

    Add item -> 
      { model 
      | items = model.items ++ [item]
      , item = ""
      }

    Remove item -> 
      { model 
      | items = List.filter (\i -> i /= item) model.items
      , item = ""
      }

view : Model -> Html Msg
view model =
  div [] 
  ( layout model ++ 
    [ ul [] 
      ( List.map 
        (\e -> li [] [text e]) 
        (List.reverse model.items)
      )
    ]
  )

layout : Model -> List (Html Msg)
layout model =
  [ h1 [] [ text "Groceries" ]
  , controls model
  ]

controls : Model -> Html Msg
controls model =
  div [ id "controls" ]
  [ input [ placeholder "Add an item", value model.item, onInput Update ] []
  , button [ id "add", onClick (Add model.item) ] [ text "Add" ]
  , button [ id "remove", onClick (Remove model.item) ] [ text "Remove" ]
  , br [] []
  ]
  