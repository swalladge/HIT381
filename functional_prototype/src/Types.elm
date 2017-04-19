module Types exposing (..)

import Html exposing (..)


-- MODEL

type alias Model =
  { page : Html Msg
  , devices : List Device
  , device_form : DeviceForm
  }


type alias DeviceForm =
  { name : String
  , address : String
  , draw : Int
  }

type alias Device =
  { name : String
  , running : Bool
  , draw : Int
  }

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

