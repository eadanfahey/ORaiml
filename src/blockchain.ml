open Core
open Result

type t = Block.t list [@@deriving yojson]


let empty = []


let validate_block curr_block prev_block =
  let open Block in
  if curr_block.prevhash <> Some (hash prev_block) then
    Error "Invalid previous block hash"
  else if prev_block.timestamp > curr_block.timestamp then
    Error "Invalid timestamp"
  else
    Ok ()


let is_genesis block = block.Block.prevhash = None


let add_block t block =
  let open Block in
  match t with
  | [] -> (match is_genesis block with
    | true  -> Ok [block]
    | false -> Error "First block cannot have a previous block hash")
  | hd :: tl -> (match validate_block block hd with
    | Ok () -> Ok (block :: t)
    | Error e -> Error e)


let to_list t = t


let get_block t ~hash =
  try
    Some (List.find (fun b -> Block.hash b = hash) t)
  with
    Not_found -> None
