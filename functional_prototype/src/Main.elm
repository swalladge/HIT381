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
  , current_device_address : String
  , current_device_draw : Int
  }


model : Model
model =
  (Model (Pages.welcome [])) [] "" "" 0


-- UPDATE

update : Msg -> Model -> Model
update msg model =
  case msg of
    Welcome ->
      { model | page = Pages.welcome model.devices }

    Home ->
      { model | page = Pages.home model.devices }

    AddDevice ->
      { model | page = Pages.add_device model.devices model.current_device_name model.current_device_address }

    AddDevice2 ->
      { model | page = Pages.add_device2 model.devices model.current_device_draw }

    UpdateName name ->
      { model | current_device_name = name }

    UpdateAddress addr ->
      { model | current_device_address = addr }

    UpdateDraw draw ->
      case String.toInt draw of
        Err msg -> { model | current_device_draw = 0 }
        Ok draw -> { model | current_device_draw = draw }

    SubmitAddDevice ->
      let
        devices = { name = model.current_device_name, running = False } :: model.devices
      in
        { model | current_device_name = "", current_device_draw = 0, current_device_address = "", devices = devices , page = Pages.home devices }





-- VIEW

view : Model -> Html Msg
view model =
  div [] [ model.page ]

