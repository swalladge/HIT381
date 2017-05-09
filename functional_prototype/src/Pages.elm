module Pages exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Types exposing (..)

name = "Smart Power"

welcome_text = "Manage your smart appliances, view power usage, save power! This is a smart home controller with a power-saving twist!"

header = div [ class "centre" ] [ h1 [] [ text name ] ]

welcome : Html Msg
welcome = div []
    [ h1 [ class "centre" ] [ text <| "Welcome to " ++ name  ]
    , p [] [ text welcome_text ]
    , hr [] []
    , button [ onClick Setup, class "btn btn-block btn-lg btn-primary" ] [ text "Get Started!" ]
    ]

setup : Html Msg
setup = div []
    [ header
    , p [] [ text "Press start to continue to the app to enter appliances manually, or 'auto find' to automatically search for appliances to control!" ]
    , hr [] []
    , button [ onClick StartExampleData, class "btn btn-block btn-lg btn-primary" ] [ text "Auto Find!" ]
    , button [ onClick Home, class "btn btn-block btn-lg btn-primary" ] [ text "Start" ]
    , button [ onClick Welcome, class "btn btn-block btn-lg btn-warning" ] [ text "Back" ]
    ]

settings : Int -> Html Msg
settings wl = div []
    [ header
    , h2 [] [ text "Settings" ]
    , p [] [ text "Settings are saved as you modify them." ]
    , label [] [
        text "Alert when consumption exceeds (Watts): "
        , input [ class "form-control", type_ "number", placeholder "0", onInput UpdateWL, value <| toString wl ] [ ]
        , p [] [ text "0 = disable alert" ]
      ]
    , hr [] []
    , button [ onClick Home, class "btn btn-block btn-lg btn-primary" ] [ text "Save and back to Home" ]
    , hr [] []
    , p [] [ text "Warning area! If you wish to reset the app back to factory defaults, click the button below." ]
    , button [ onClick ConfirmReset, class "btn btn-block btn-lg btn-danger" ] [ text "Reset App" ]
    ]



home : List Device -> Int -> Html Msg
home d wl =
  let
      n_running = (List.length (List.filter (\a -> a.running) d))
      n         = (List.length d)
      draw      = (List.sum (List.map (\d -> d.draw) (List.filter (\d -> d.running) d)))
      isWarning   = if wl > 0 && draw > wl then True else False
      warning   = if isWarning then
          p [] [ text <| "(greater than " ++ (toString wl) ++ "W!)" ]
        else
          span [] []
  in
    div []
      [
        header
      , h2 [] [ text "Status" ]
      , div [ class "panel panel-default" ]
          [ div [ class "panel-heading" ] [ text "Current power consumption" ]
          , div [ class <| "panel-body bg-" ++ (if isWarning then "danger" else "success") ]
            [ text ((toString draw) ++ " Watts")
            , warning
            ]
          ]
      , div [ class "panel-body" ] [ text ((toString n) ++ " appliance" ++ (if n == 1 then "" else "s") ++ " (" ++ (toString n_running) ++ " running)") ]
      , h2 [] [ text "Appliances" ]
      , div [] [
          device_list d
        ]
      , hr [] []
      , button [ onClick <| AddDevice True, class "btn btn-block btn-lg btn-primary" ] [ text "Add Appliance" ]
      , button [ onClick Settings, class "btn btn-block btn-lg btn-warning" ] [ text "Settings" ]
      ]

display_device : Device -> Html Msg
display_device device = 
  button [ class "btn btn-block btn-lg btn-default", style [("cursor", "pointer")], onClick (ViewDevice device.id) ] [
      div [ class "pull-left" ] [ text device.name ]
    , div [ class <| "status-icon pull-right " ++ (if device.running then "on" else "off") ] [
        text (if device.running then "on" else "off")
      ]
    ]


device_list : List Device -> Html Msg
device_list devices = div [] (
  if (List.length devices) == 0 then
    [ div [] [ text "No smart appliances connected yet. Click the button below to add one!" ] ]
  else
    (List.map display_device devices)
  )


add_device : List Device -> String -> String -> String -> Html Msg
add_device devices name addr message = div []
  [
    header
  , h2 [] [ text "Add Appliance" ]
  , p [] [ text "Connect a smart appliance to manage it from this app." ]
  , if (String.length message) /= 0 then
      div [ class "alert alert-warning" ] [ text message ]
    else
      span [] []
  , label [] [
      text "Name: "
    , input [ class "form-control", type_ "text", placeholder "Kitchen Light", maxlength 20, onInput UpdateName, value name ] [ ]
    ]
    , hr [] []
    , button [ onClick AddDevice2, class "btn btn-block btn-lg btn-primary" ] [ text "Next" ]
    , button [ onClick Home, class "btn btn-block btn-lg btn-warning" ] [ text "Back to Home" ]
    ]

add_device2 : List Device -> Int -> String -> Html Msg
add_device2 devices draw msg = div []
  [
    header
  , h2 [] [ text "Add Appliance" ]
  , if (String.length msg) > 0 then
      div [ class "alert alert-warning" ] [ text msg ]
    else
      span [] []
  , label [] [
      text "Power Consumption (Watts): "
    , input [ class "form-control", type_ "number", placeholder "0", onInput UpdateDraw, value (if draw > 0 then (toString draw) else "") ] [ ]
    ]
  , hr [] []
  , button [ onClick SubmitAddDevice, class "btn btn-block btn-lg btn-primary" ] [ text "Save" ]
  , button [ onClick <| AddDevice False, class "btn btn-lg btn-block btn-warning" ] [ text "Back" ]
  ]


confirm_reset : Html Msg
confirm_reset =
  div []
    [
      header
    , h2 [] [ text "Reset" ]
    , b [] [ text "Are you sure? This will remove all your settings and connected appliances." ]
    , hr [] []
    , button [ onClick Reset, class "btn btn-block btn-lg btn-danger" ] [ text "Confirm Reset" ]
    , button [ onClick Settings, class "btn btn-block btn-lg btn-primary" ] [ text "Cancel" ]
    ]

view_device : Device -> Html Msg
view_device device =
  div []
    [
      header
    , h2 [] [ text device.name ]
    , button [ onClick (ToggleDevice device.id), class ("btn btn-block btn-lg " ++ if device.running then "active btn-success" else "btn-danger"), attribute "data-toggle" "button" ] [ text (if device.running then ("On (" ++ (toString device.draw) ++ "W)") else "Off (0W)") ]
    , p [] []
    , p [] [ text <| if device.running then "" else
          ("Power consumption when running: " ++ (toString device.draw) ++ "W") ]
    , hr [] []
    , button [ onClick (EditDevice device.id), class "btn btn-block btn-lg btn-info" ] [ text "Edit Appliance" ]

    , button [ onClick Home, class "btn btn-block btn-lg btn-warning" ] [ text "Back to Home" ]
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
    , input [ class "form-control", type_ "text", placeholder "Name", maxlength 20, onInput UpdateName, value device.name ] [ ]
    ]
  , label [] [
    text "Power Consumption (Watts): "
  , input [ class "form-control", type_ "number", placeholder "0", onInput UpdateDraw, value (if device.draw > 0 then (toString device.draw) else "") ] [ ]
  ]
  , hr [] []
  , button [ onClick <| SaveDevice device.id, class "btn btn-block btn-lg btn-primary" ] [ text "Save" ]
  , button [ onClick <| ViewDevice device.id, class "btn btn-block btn-lg btn-warning" ] [ text "Cancel" ]
  ]
