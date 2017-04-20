module Types exposing (..)

import Html exposing (..)


-- MODEL

type alias Model =
  { page : Html Msg
  , devices : List Device
  , max_id : Int
  , device_form : DeviceForm
  , message : String
  }

type alias StrippedModel =
  { devices : List Device
  , max_id : Int
  , device_form : DeviceForm
  , message : String
  }

type alias DeviceForm =
  { name : String
  , address : String
  , draw : Int
  }

type alias Device =
  { id : Int
  , name : String
  , running : Bool
  , draw : Int
  }

type Msg
    = Welcome
    | Setup
    | Settings
    | Reset
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

empty_device_form : DeviceForm
empty_device_form =
  { name = ""
  , address = ""
  , draw = 0
  }

