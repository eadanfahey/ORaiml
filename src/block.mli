open Core

type t = {
  timestamp: float;
  transactions: Transaction.t list;
  prevhash: string option;
  nonce: int;
}

(* Mine a block given some data and the previous block hash *)
val mine: transactions:Transaction.t list -> prevhash:string option -> t

(* Compute the hash of a block *)
val hash: t -> string

val of_yojson : Yojson.Safe.json -> (t, string) result

val to_yojson : t -> Yojson.Safe.json

val transactions: t -> Transaction.t list
