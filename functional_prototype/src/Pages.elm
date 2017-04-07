module Pages exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)


type Msg
    = Welcome
    | Home
    | AddDevice
    | UpdateName String
    | SubmitAddDevice

type alias Device =
  { name : String
  }

header = div [] [ text "Electricity Alert" ]

welcome : List Device -> Html Msg
welcome d = div []
    [ div [] [ text "welcome" ]
    , button [ onClick Home ] [ text "Get Started!" ]
    ]


home : List Device -> Html Msg
home d = div []
    [
      header
    , div [] [ text "status" ]
    , div [] [ text "power draw" ]
    , div [] [
        device_list d
      , button [ onClick AddDevice ] [ text "Add Appliance" ]
      ]

    ]


device_list devices = div [] (List.map (\d -> div [] [ text d.name ]) devices)

add_device devices = div []
  [
    header
  , div [] [ text "add device" ]
  , label [] [
      text "Name: "
    , input [ type_ "text", placeholder "Name", onInput UpdateName ] []
    ]
  , button [ onClick SubmitAddDevice ] [ text "Add Device" ]
  ]

