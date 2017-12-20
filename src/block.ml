open Core

type t = {
  timestamp: float;
  data: string;
  prevhash: string option;
  nonce: int;
} [@@deriving yojson]


let to_epoch time = Time.(diff time epoch |> Span.to_sec)


let mine ~data ~prevhash =
  let timestamp = Time.now () |> to_epoch in
  let nonce = 0 in
  {timestamp; data; prevhash; nonce}


let sha256 s =
  let hasher = Cryptokit.Hash.sha256 () in
  let encode_hex = Cryptokit.Hexa.encode () in
  let hash = Cryptokit.hash_string hasher s in
  Cryptokit.transform_string encode_hex hash


let hash t =
  to_yojson t
  |> Yojson.Safe.to_string
  |> sha256
