import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Pages exposing (..)

main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { page : Html Msg
  , devices : List Device
  , current_device_name : String
  }


model : Model
model =
  (Model (Pages.welcome [])) [] ""


-- UPDATE

update : Msg -> Model -> Model
update msg model =
  case msg of
    Welcome ->
      { model | page = Pages.welcome model.devices }

    Home ->
      { model | page = Pages.home model.devices }

    AddDevice ->
      { model | page = Pages.add_device model.devices }

    UpdateName name ->
      { model | current_device_name = name }

    SubmitAddDevice ->
      let
        devices = { name = model.current_device_name } :: model.devices
      in
        { model | current_device_name = "", devices = devices , page = Pages.home devices }





-- VIEW

view : Model -> Html Msg
view model =
  div [] [ model.page ]

