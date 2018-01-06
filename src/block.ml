open Core
open Bignum

type t = {
  timestamp: float;
  transactions: Transaction.t list;
  prevhash: string option;
  nonce: int;
} [@@deriving yojson]

let hash t = to_yojson t |> Yojson.Safe.to_string |> Util.sha256

let mine ~transactions ~prevhash =
  let timestamp = Time.now () |> Util.to_epoch in
  let rec mine_loop block =
    let hash_int = Bigint.Hex.of_string ("0x" ^ (hash block)) in
    match Bigint.(hash_int < Constants.pow_target) with
    | true  -> block
    | false -> mine_loop {block with nonce = block.nonce + 1}
  in
  mine_loop {timestamp; transactions; prevhash; nonce = 0}

let transactions t = t.transactions
