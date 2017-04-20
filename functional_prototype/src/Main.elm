import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Types exposing (..)
import Pages exposing (..)
import Functions exposing (..)

main =
  Html.beginnerProgram { model = model, view = view, update = update }


model : Model
model =
  { page = Pages.welcome
  , devices = []
  , max_id = 0
  , device_form = empty_device_form
  }

-- UPDATE

update : Msg -> Model -> Model
update msg model =
  case msg of
    Welcome ->
      { model | page = Pages.welcome }

    Setup ->
      { model | page = Pages.setup }

    Home ->
      { model | page = Pages.home model.devices }

    AddDevice ->
      { model | page = Pages.add_device model.devices model.device_form.name model.device_form.address }

    AddDevice2 ->
      { model | page = Pages.add_device2 model.devices model.device_form.draw }

    UpdateName name ->
      let
        form = model.device_form
      in
        { model | device_form = { form | name = name } }

    UpdateAddress addr ->
      let
        form = model.device_form
      in
        { model | device_form = { form | address = addr } }

    UpdateDraw draw ->
      let
          form = model.device_form
      in
        case String.toInt draw of
          Err msg -> { model | device_form = { form | draw = 0 } }
          Ok draw -> { model | device_form = { form | draw = draw } }

    SubmitAddDevice ->
      let
        devices = (List.sortBy .name ((Device model.max_id model.device_form.name False model.device_form.draw) :: model.devices))
      in
        { model | max_id = model.max_id + 1, device_form = empty_device_form, devices = devices, page = Pages.home devices }

    ViewDevice id ->
      { model | page = Pages.view_device <| get_device model.devices id }

    EditDevice id ->
      { model | page = Pages.edit_device <| get_device model.devices id }

    ToggleDevice id ->
      let
        devices = (List.indexedMap (toggle id) model.devices)
      in
        { model | page = Pages.view_device <| get_device devices id, devices = devices }


toggle : Int -> Int -> Device -> Device
toggle target id device =
  if id == target then
    { device | running = not device.running }
  else
    device


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "container" ] [ model.page ]

