port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Types exposing (..)
import Pages exposing (..)
import Functions exposing (..)

new_model : Model
new_model =
  { page = Pages.welcome
  , devices = []
  , max_id = 0
  , device_form = empty_device_form
  , message = ""
  , warning_level = 0
  , setup_complete = False
  }


main : Program (Maybe StrippedModel) Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = updateWithStorage
        , subscriptions = \_ -> Sub.none
        }


port setStorage : StrippedModel -> Cmd msg
port resetStorage : Bool -> Cmd msg

init : Maybe StrippedModel -> ( Model, Cmd Msg )
init savedModel =
  case savedModel of
    Nothing -> new_model ! []
    Just {devices, max_id, device_form, warning_level, setup_complete} -> Model (if setup_complete then Pages.home devices warning_level else Pages.welcome) devices max_id device_form "" warning_level setup_complete ! []

updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        (newModel, cmds) = update msg model
    in
        ( newModel
        , Cmd.batch [ setStorage { devices = newModel.devices, max_id = newModel.max_id, device_form = newModel.device_form, message = "", warning_level = newModel.warning_level, setup_complete = newModel.setup_complete }, cmds ]
        )


-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Welcome ->
      { model | page = Pages.welcome } ! []

    Setup ->
      { model | page = Pages.setup } ! []

    Home ->
      { model | message = "", page = Pages.home model.devices model.warning_level, setup_complete = True } ! []

    Settings ->
      { model | page = Pages.settings model.warning_level } ! []

    UpdateWL wl ->
      let
        warning_level = case String.toInt wl of
          Err msg -> 0
          Ok w -> w
      in
        { model | warning_level = warning_level } ! []

    Reset ->
        { new_model | page = Pages.welcome } ! [ resetStorage True ]

    AddDevice reset ->
      let
        device_form = if reset then empty_device_form else model.device_form
      in
        { model | device_form = device_form, page = Pages.add_device model.devices device_form.name device_form.address model.message } ! []

    AddDevice2 ->
      let
          (message, page) = if (String.length model.device_form.name) == 0 then
              let msg = "Name is required!"
              in (msg, Pages.add_device model.devices model.device_form.name model.device_form.address msg)
            else
              ("", Pages.add_device2 model.devices model.device_form.draw "")
      in
          { model | page = page, message = message} ! []

    UpdateName name ->
      let
        form = model.device_form
      in
        { model | device_form = { form | name = name } } ! []

    UpdateAddress addr ->
      let
        form = model.device_form
      in
        { model | device_form = { form | address = addr } } ! []

    UpdateDraw draw ->
      let
          form = model.device_form
      in
        case String.toInt draw of
          Err msg -> { model | device_form = { form | draw = -1 } } ! []
          Ok draw -> { model | device_form = { form | draw = draw } } ! []

    SubmitAddDevice ->
      let
        (page, devices, device_form) = if (not (isPositiveInt model.device_form.draw)) then
              let msg = "Power consumption must be a positive integer!"
              in (Pages.add_device2 model.devices model.device_form.draw msg,
                  model.devices, model.device_form)
          else
            let d = (List.sortBy .name ((Device model.max_id model.device_form.name False model.device_form.draw) :: model.devices))
            in (Pages.view_device <| get_device d model.max_id, d, empty_device_form)
      in
        { model | max_id = model.max_id + 1, device_form = device_form, devices = devices, page = page } ! []

    ViewDevice id ->
      { model | page = Pages.view_device <| get_device model.devices id } ! []

    EditDevice id ->
      let
        device = get_device model.devices id
        device_form = model.device_form
      in
        { model | page = Pages.edit_device "" device, device_form = { device_form | name = device.name, draw = device.draw } } ! []

    -- on edit save
    SaveDevice id ->
      let
        (devices, message, page) = if (String.length model.device_form.name) == 0 then
          (model.devices, "Name is required!", Pages.edit_device "Name is required!")
        else if (not <| isPositiveInt model.device_form.draw) then
          (model.devices, "Draw must be a positive integer!", Pages.edit_device "Draw must be a positive integer!")
        else
          (List.map (save_device model.device_form id) model.devices, ""
          , Pages.view_device )
      in
        { model | message = message, page = page <| get_device devices id, devices = devices } ! []

    ToggleDevice id ->
      let
        devices = (List.map (toggle id) model.devices)
      in
        { model | page = Pages.view_device <| get_device devices id, devices = devices } ! []

    ConfirmReset ->
        { model | page = Pages.confirm_reset } ! []

    StartExampleData ->
      let
          make_device i (name, running, draw) = Device i name running draw
          devices = List.sortBy .name <| List.indexedMap make_device
            [ (,,) "Kitchen light" True 20
            , (,,) "Study light" False 20
            , (,,) "Dining room light" False 20
            , (,,) "Lounge light" False 20
            , (,,) "Shed floodlight" False 200
            , (,,) "Toaster" False 1000
            , (,,) "Fridge" True 200
            , (,,) "Dish washer" False 500
            , (,,) "Desktop computer" True 350
            ]
          warning_level = 1000
      in
        { page = Pages.home devices warning_level
        , devices = devices
        , max_id = List.length devices
        , device_form = empty_device_form
        , message = ""
        , warning_level = warning_level
        , setup_complete = True
        } ! []


toggle : Int -> Device -> Device
toggle target device =
  if device.id == target then
    { device | running = not device.running }
  else
    device

save_device : DeviceForm -> Int -> Device -> Device
save_device form target_id device =
  if device.id == target_id then
    { device | name = form.name, draw = form.draw }
  else
    device

-- VIEW

view : Model -> Html Msg
view model =
    div [ class "container" ] [ model.page ]

