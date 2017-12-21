open Core
open Bignum

type t = {
  timestamp: float;
  data: string;
  prevhash: string option;
  nonce: int;
} [@@deriving yojson]


let to_epoch time = Time.(diff time epoch |> Span.to_sec)


let sha256 s =
  let hasher = Cryptokit.Hash.sha256 () in
  let encode_hex = Cryptokit.Hexa.encode () in
  let hash = Cryptokit.hash_string hasher s in
  Cryptokit.transform_string encode_hex hash


let hash t = to_yojson t |> Yojson.Safe.to_string |> sha256


let mine ~data ~prevhash =
  let timestamp = Time.now () |> to_epoch in
  let rec mine_loop block =
    let hash_int = Bigint.Hex.of_string ("0x" ^ (hash block)) in
    match Bigint.(hash_int < Constants.pow_target) with
    | true  -> block
    | false -> mine_loop {block with nonce = block.nonce + 1}
  in
  mine_loop {timestamp; data; prevhash; nonce = 0}
