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


device_list : List Device -> Html Msg
device_list devices = div [] (List.map (\d -> div [] [ text d.name ]) (List.sortBy .name devices))

add_device : List Device -> Html Msg
add_device devices = div []
  [
    header
  , div [] [ text "Add Appliance" ]
  , label [] [
      text "Name: "
    , input [ type_ "text", placeholder "Name", onInput UpdateName ] []
    ]
  , button [ onClick SubmitAddDevice ] [ text "Add Device" ]
  ]

