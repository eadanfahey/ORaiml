(* A blockchain *)
type t

(* A new blockchain  *)
val empty: t

(* Add a block to a blockchain *)
val add_block: t -> Block.t -> (t, string) Result.result

(* Convert a blockchain to a list of Blocks *)
val to_list: t -> Block.t list

(* Get a block from a blockchain with a given hash *)
val get_block: t -> hash:string -> Block.t option

val of_yojson : Yojson.Safe.json -> (t, string) Result.result

val to_yojson : t -> Yojson.Safe.json
