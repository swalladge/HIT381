module Pages exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type Msg
    = Welcome
    | Home
    | AddDevice
    | AddDevice2
    | UpdateName String
    | UpdateAddress String
    | UpdateDraw String
    | SubmitAddDevice
    | ViewDevice Int
    | ToggleDevice Int

type alias Device =
  { name : String
  , running : Bool
  }

header = div [ class "centre" ] [ h1 [] [ text "Electricity Alert" ] ]

welcome : List Device -> Html Msg
welcome d = div []
    [ h1 [ class "centre" ] [ text "Welcome to Electricity Alert!" ]
    , button [ onClick Home, class "btn btn-block btn-lg btn-primary" ] [ text "Get Started!" ]
    ]


home : List Device -> Html Msg
home d = div []
    [
      header
    , div [] [
        text "status: "
      , text ((toString (List.length d)) ++ " appliance" ++ (if (List.length d) == 1 then "" else "s"))
      ]
    -- , div [] [ text "power draw" ]
    , div [] [
        device_list d
      , button [ onClick AddDevice, class "btn btn-block btn-lg btn-primary" ] [ text "Add Appliance" ]
      ]

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
device_list devices = div [] (List.indexedMap device_in_list devices)


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
    , input [ class "form-control", type_ "number", placeholder "0", onInput UpdateDraw, value (toString draw) ] [ ]
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
  , div [ class (if device.running then "well on" else "well off") ] [
      text (if device.running then "on" else "off")
    ]
  , button [ onClick (ToggleDevice index), class "btn btn-block btn-lg btn-primary" ] [ text (if device.running then "Switch off" else "Switch on") ]

  , button [ onClick Home, class "btn btn-block btn-lg btn-warning" ] [ text "Back" ]
  ]


get : Int -> List Device -> Device
get index list =
  case List.head (List.drop index list) of
    Nothing -> { name = "INVALID", running = False }
    Just device -> device

