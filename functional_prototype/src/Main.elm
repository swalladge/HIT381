import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Types exposing (..)
import Pages exposing (..)

main =
  Html.beginnerProgram { model = model, view = view, update = update }


empty_device_form = DeviceForm "" "" 0

model : Model
model =
  (Model (Pages.welcome)) [] empty_device_form


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
        devices = (List.sortBy .name ((Device model.device_form.name False model.device_form.draw) :: model.devices))
      in
        { model | device_form = empty_device_form, devices = devices, page = Pages.home devices }

    ViewDevice index ->
      { model | page = Pages.view_device model.devices index }

    EditDevice index ->
      { model | page = Pages.edit_device model.devices index }

    ToggleDevice index ->
      let
        devices = (List.indexedMap (toggle index) model.devices)
      in
        { model | page = Pages.view_device devices index, devices = devices }


toggle : Int -> Int -> Device -> Device
toggle target index device =
  if index == target then
    { device | running = not device.running }
  else
    device


-- VIEW

view : Model -> Html Msg
view model =
  div [ class "container" ] [ model.page ]

