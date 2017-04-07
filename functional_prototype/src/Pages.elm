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

type alias Device =
  { name : String
  , running : Bool
  }

header = div [] [ text "Electricity Alert" ]

welcome : List Device -> Html Msg
welcome d = div []
    [ div [] [ text "Welcome to Electricity Alert!" ]
    , button [ onClick Home ] [ text "Get Started!" ]
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
      , button [ onClick AddDevice ] [ text "Add Appliance" ]
      ]

    ]


device_in_list : Int -> Device -> Html Msg
device_in_list index device = div [ onClick (ViewDevice index)] [
    text device.name
  , text (if device.running then " (running)" else " (off)")
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
    , input [ type_ "text", placeholder "Name", onInput UpdateName, value name ] [ ]
    ]
  , label [] [
      text "Address: "
    , input [ type_ "text", placeholder "https://10.0.0.1", onInput UpdateAddress, value addr ] []
    ]
  , button [ onClick AddDevice2 ] [ text "Next" ]
  , button [ onClick Home ] [ text "Back to Home" ]
  ]

add_device2 : List Device -> Int -> Html Msg
add_device2 devices draw = div []
  [
    header
  , div [] [ text "Add Appliance" ]
  , label [] [
      text "Power Draw (watts): "
    , input [ type_ "number", placeholder "0", onInput UpdateDraw, value (toString draw) ] [ ]
    ]
  , button [ onClick SubmitAddDevice ] [ text "Save" ]
  , button [ onClick AddDevice ] [ text "Back" ]
  ]


view_device : List Device -> Int -> Html Msg
view_device devices index =
  let device = get index devices
  in div []
  [
    text (device.name)
  , text (if device.running then " (running)" else " (off)")
  , button [ onClick Home ] [ text "Back" ]
  ]


get : Int -> List Device -> Device
get index list =
  case List.head (List.drop index list) of
    Nothing -> { name = "INVALID", running = False }
    Just device -> device

