module Pages exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type Msg
    = Welcome
    | Setup
    | Home
    | AddDevice
    | AddDevice2
    | UpdateName String
    | UpdateAddress String
    | UpdateDraw String
    | SubmitAddDevice
    | ViewDevice Int
    | EditDevice Int
    | ToggleDevice Int

type alias Device =
  { name : String
  , running : Bool
  , draw : Int
  }

name = "Smart Power"

welcome_text = "Manage your smart appliances, view power usage, save power!"

header = div [ class "centre" ] [ h1 [] [ text name ] ]

welcome : Html Msg
welcome = div []
    [ h1 [ class "centre" ] [ text <| "Welcome to " ++ name  ]
    , p [] [ text welcome_text ]
    , button [ onClick Setup, class "btn btn-block btn-lg btn-primary" ] [ text "Get Started!" ]
    ]

setup : Html Msg
setup = div []
    [ header
    , p [] [ text "Setup - house location, etc. TODO" ]
    , p [] [ text "Ignore for now." ]
    , button [ onClick Home, class "btn btn-block btn-lg btn-primary" ] [ text "Enter" ]
    , button [ onClick Welcome, class "btn btn-block btn-lg btn-warning" ] [ text "Back" ]
    ]



home : List Device -> Html Msg
home d =
  let
      n_running = (List.length (List.filter (\a -> a.running) d))
      n         = (List.length d)
      draw      = (List.sum (List.map (\d -> d.draw) (List.filter (\d -> d.running) d)))
  in
    div []
      [
        header
      , h2 [] [ text "status" ]
      , div [] [ text ((toString n) ++ " appliance" ++ (if n == 1 then "" else "s") ++ " (" ++ (toString n_running) ++ " running)") ]
      , div [] [ text ("Power draw: " ++ (toString draw) ++ "W") ]
      , h2 [] [ text "Appliances" ]
      , div [] [
          device_list d
        ]
      , button [ onClick AddDevice, class "btn btn-block btn-lg btn-primary" ] [ text "Add Appliance" ]
      ]

device_in_list : Int -> Device -> Html Msg
device_in_list index device = div [ class "device-listing panel panel-warning", onClick (ViewDevice index)] [
  div [ class "panel-heading" ] [
      text device.name
    , div [ class (if device.running then "status-icon on" else "status-icon off") ] [
        text (if device.running then "on" else "off")
      ]
    ]
  ]


device_list : List Device -> Html Msg
device_list devices = div [] (
  if (List.length devices) == 0 then
    [ div [] [ text "no appliances registered yet" ] ]
  else
    (List.indexedMap device_in_list devices)
  )


add_device : List Device -> String -> String -> Html Msg
add_device devices name addr = div []
  [
    header
  , div [] [ text "Add Appliance" ]
  , label [] [
      text "Name: "
    , input [ class "form-control", type_ "text", placeholder "Name", onInput UpdateName, value name ] [ ]
    ]
  , label [] [
      text "Address: "
    , input [ class "form-control", type_ "text", placeholder "https://10.0.0.1", onInput UpdateAddress, value addr ] []
    ]
  , button [ onClick AddDevice2, class "btn btn-block btn-lg btn-primary" ] [ text "Next" ]
  , button [ onClick Home, class "btn btn-block btn-lg btn-warning" ] [ text "Back to Home" ]
  ]

add_device2 : List Device -> Int -> Html Msg
add_device2 devices draw = div []
  [
    header
  , div [] [ text "Add Appliance" ]
  , label [] [
      text "Power Draw (watts): "
    , input [ class "form-control", type_ "number", placeholder "0", onInput UpdateDraw, value (if draw > 0 then (toString draw) else "") ] [ ]
    ]
  , button [ onClick SubmitAddDevice, class "btn btn-block btn-lg btn-primary" ] [ text "Save" ]
  , button [ onClick AddDevice, class "btn btn-lg btn-block btn-warning" ] [ text "Back" ]
  ]


view_device : List Device -> Int -> Html Msg
view_device devices index =
  let device = get index devices
  in div []
  [
    header
  , h2 [] [ text ("Manage " ++ device.name) ]
  , div [] [ text ("Power draw when running: " ++ (toString device.draw) ++ "W") ]
  , div [ class (if device.running then "well on" else "well off") ] [
      text (if device.running then "on" else "off")
    ]
  , button [ onClick (ToggleDevice index), class "btn btn-block btn-lg btn-primary" ] [ text (if device.running then "Switch off" else "Switch on") ]
  , button [ onClick (EditDevice index), class "btn btn-block btn-lg btn-info" ] [ text "Edit Appliance" ]

  , button [ onClick Home, class "btn btn-block btn-lg btn-warning" ] [ text "Back" ]
  ]


get : Int -> List Device -> Device
get index list =
  case List.head (List.drop index list) of
    Nothing -> { name = "INVALID", running = False, draw = 0 }
    Just device -> device

edit_device : List Device -> Int -> Html Msg
edit_device devices index =
  let
    device = get index devices
  in
    div []
    [
      header
    , h2 [] [ text ("Edit " ++ device.name) ]
    , p [] [ text "TODO: edit forms" ]
    , button [ onClick <| ViewDevice index, class "btn btn-block btn-lg btn-primary" ] [ text "Save" ]
    , button [ onClick <| ViewDevice index, class "btn btn-block btn-lg btn-warning" ] [ text "Cancel" ]
    ]

