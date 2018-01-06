open Core

let to_epoch time = Time.(diff time epoch |> Span.to_sec)

let sha256 s =
  let hasher = Cryptokit.Hash.sha256 () in
  let encode_hex = Cryptokit.Hexa.encode () in
  let hash = Cryptokit.hash_string hasher s in
  Cryptokit.transform_string encode_hex hash
