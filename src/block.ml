open Core

type t = {
  timestamp: int;
  data: string;
  prevhash: string option;
  nonce: int;
} [@@deriving yojson]


let mine ~data ~prevhash =
  let timestamp = Time.now () |> Time.to_epoch |> int_of_float in
  let nonce = 0 in
  {timestamp; data; prevhash; nonce}


let serialize t = to_yojson t |> Yojson.Safe.to_string


let deserialize s = Yojson.Safe.from_string s |> of_yojson


let sha256 s =
  let hasher = Cryptokit.Hash.sha256 () in
  let encode_hex = Cryptokit.Hexa.encode () in
  let hash = Cryptokit.hash_string hasher s in
  Cryptokit.transform_string encode_hex hash


let hash t = serialize t |> sha256
