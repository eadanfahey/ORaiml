open Core
open Result
open Bignum

type t = {
  blocks: Block.t list;
  utxo: Utxo.t;
} [@@deriving yojson]

let empty = {blocks = []; utxo = Utxo.empty}

let validate_block curr_block prev_block =
  let open Block in
  let hash_int = Bigint.Hex.of_string ("0x" ^ (hash curr_block)) in
  if curr_block.prevhash <> Some (hash prev_block) then
    Error "Invalid previous block hash"
  else if prev_block.timestamp > curr_block.timestamp then
    Error "Invalid timestamp"
  else if Bigint.(hash_int > Constants.pow_target) then
    Error "Invalid nonce"
  else
    Ok ()

let is_genesis block = block.Block.prevhash = None

let add_block t block =
  let utxo = List.fold (Block.transactions block) ~init:t.utxo ~f:Utxo.update in
  match t.blocks with
  | [] -> (match is_genesis block with
    | true  -> Ok {blocks = [block]; utxo = utxo}
    | false -> Error "First block cannot have a previous block hash")
  | hd :: tl -> (match validate_block block hd with
    | Ok () -> Ok {blocks = block :: t.blocks; utxo = utxo}
    | Error e -> Error e)

let blocks t = t.blocks

let utxo t = t.utxo

let get_block t ~hash = List.find t.blocks (fun b -> Block.hash b = hash)

let to_file t filename =
  let data = to_yojson t |> Yojson.Safe.to_string in
  Out_channel.write_all filename ~data:data

let from_file filename =
  let data = In_channel.read_all filename in
  match Yojson.Safe.from_string data |> of_yojson with
  | Ok bc -> bc
  | Error e -> failwith e
