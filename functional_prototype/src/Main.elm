import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Pages exposing (..)

main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { page : Html Msg
  }


model : Model
model =
  Model Pages.welcome


-- UPDATE

update : Msg -> Model -> Model
update msg model =
  case msg of
    Welcome ->
      { model | page = Pages.welcome }

    Login ->
      { model | page = Pages.login }


-- VIEW

view : Model -> Html Msg
view model =
  div [] [ model.page ]

