module Functions exposing (..)

import Types exposing (..)

get_device : List Device -> Int -> Device
get_device list id =
  case List.head (List.filter (\d -> d.id == id) list) of
    Nothing -> { name = "INVALID", id = -1, running = False, draw = 0 }
    Just device -> device

