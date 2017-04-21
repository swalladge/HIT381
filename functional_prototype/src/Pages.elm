module Pages exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Types exposing (..)

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

settings : Int -> Html Msg
settings wl = div []
    [ header
    , h2 [] [ text "Settings" ]
    , p [] [ text "settings and such" ]
    , label [] [
        text "Alert when draw exceeds (watts): "
        , input [ class "form-control", type_ "number", placeholder "0", onInput UpdateWL, value <| toString wl ] [ ]
      ]
    , button [ onClick ConfirmReset, class "btn btn-block btn-lg btn-danger" ] [ text "Reset" ]
    , button [ onClick Home, class "btn btn-block btn-lg btn-primary" ] [ text "Back" ]
    ]



home : List Device -> Int -> Html Msg
home d wl =
  let
      n_running = (List.length (List.filter (\a -> a.running) d))
      n         = (List.length d)
      draw      = (List.sum (List.map (\d -> d.draw) (List.filter (\d -> d.running) d)))
      warning   = if wl > 0 && draw > wl then
          p [] [ text <| "Warning, draw is greater than " ++ (toString wl) ++ "W!" ]
        else
          span [] []
  in
    div []
      [
        header
      , h2 [] [ text "Status" ]
      , warning
      , div [] [ text ((toString n) ++ " appliance" ++ (if n == 1 then "" else "s") ++ " (" ++ (toString n_running) ++ " running)") ]
      , div [] [ text ("Power draw: " ++ (toString draw) ++ "W") ]
      , h2 [] [ text "Appliances" ]
      , div [] [
          device_list d
        ]
      , button [ onClick AddDevice, class "btn btn-block btn-lg btn-primary" ] [ text "Add Appliance" ]
      , button [ onClick Settings, class "btn btn-block btn-lg btn-warning" ] [ text "Settings" ]
      ]

display_device : Device -> Html Msg
display_device device = div [ class "device-listing panel panel-warning", onClick (ViewDevice device.id)] [
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
    (List.map display_device devices)
  )


add_device : List Device -> String -> String -> String -> Html Msg
add_device devices name addr message = div []
  [
    header
  , div [] [ text "Add Appliance" ]
  , if (String.length message) /= 0 then
      div [] [ text message ]
    else
      span [] []
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


confirm_reset : Html Msg
confirm_reset =
  div []
    [
      header
    , h2 [] [ text "Reset" ]
    , b [] [ text "Are you sure? This will remove all your settings and revert the app to a freshly installed state." ]
    , button [ onClick Reset, class "btn btn-block btn-lg btn-danger" ] [ text "Confirm Reset" ]
    , button [ onClick Settings, class "btn btn-block btn-lg btn-primary" ] [ text "Cancel" ]
    ]

view_device : Device -> Html Msg
view_device device =
  div []
    [
      header
    , h2 [] [ text ("Manage " ++ device.name) ]
    , div [] [ text ("Power draw when running: " ++ (toString device.draw) ++ "W") ]
    , div [ class (if device.running then "well on" else "well off") ] [
        text (if device.running then "on" else "off")
      ]
    , button [ onClick (ToggleDevice device.id), class "btn btn-block btn-lg btn-primary" ] [ text (if device.running then "Switch off" else "Switch on") ]
    , button [ onClick (EditDevice device.id), class "btn btn-block btn-lg btn-info" ] [ text "Edit Appliance" ]

    , button [ onClick Home, class "btn btn-block btn-lg btn-warning" ] [ text "Back" ]
    ]

edit_device : String -> Device -> Html Msg
edit_device message device =
  div []
  [
    header
  , h2 [] [ text ("Edit " ++ device.name) ]
  , if (String.length message) > 0 then
      p [] [ text message ]
    else
      span [] []
  , label [] [
      text "Name: "
    , input [ class "form-control", type_ "text", placeholder "Name", onInput UpdateName, value device.name ] [ ]
    ]
  , label [] [
    text "Power Draw (watts): "
  , input [ class "form-control", type_ "number", placeholder "0", onInput UpdateDraw, value (if device.draw > 0 then (toString device.draw) else "") ] [ ]
  ]
  , button [ onClick <| SaveDevice device.id, class "btn btn-block btn-lg btn-primary" ] [ text "Save" ]
  , button [ onClick <| ViewDevice device.id, class "btn btn-block btn-lg btn-warning" ] [ text "Cancel" ]
  ]
