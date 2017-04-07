module Pages exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)


type Msg
    = Welcome
    | Login



welcome = div []
    [ button [ onClick Login ] [ text "Login" ]
    , div [] [ text "welcome" ]
    ]


login = div []
    [ button [ onClick Welcome ] [ text "welcome page" ]
    , div [] [ text "Login" ]
    ]
