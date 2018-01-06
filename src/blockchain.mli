(* A blockchain *)
type t

(* A new blockchain  *)
val empty: t

(* Add a block to a blockchain *)
val add_block: t -> Block.t -> (t, string) Result.result

(* The blocks in the blockchain *)
val blocks: t -> Block.t list

(* The UTXO set of the blockchain *)
val utxo: t -> Utxo.t

(* Get a block from a blockchain with a given hash *)
val get_block: t -> hash:string -> Block.t option

val of_yojson : Yojson.Safe.json -> (t, string) Result.result

val to_yojson : t -> Yojson.Safe.json

(* Open a blockchain from file*)
val from_file: string -> t

(* Save a blockchain to file *)
val to_file: t -> string -> unit
