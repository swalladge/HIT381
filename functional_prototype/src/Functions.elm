module Functions exposing (..)

import Types exposing (..)

get_device : List Device -> Int -> Device
get_device list id =
  case List.head (List.filter (\d -> d.id == id) list) of
    Nothing -> { name = "INVALID", id = -1, running = False, draw = 0 }
    Just device -> device


isInt : String -> Bool
isInt str =
  case String.toInt str of
    Err _ -> False
    Ok  _ -> True

isPositiveInt : Int -> Bool
isPositiveInt n =
  if n >= 0 then
    True
  else
    False
