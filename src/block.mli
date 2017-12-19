type t = {
  timestamp: int;
  data: string;
  prevhash: string option;
  nonce: int;
}

(* Mine a block given some data and the previous block hash *)
val mine: data:string -> prevhash:string option -> t

(* Compute the hash of a block *)
val hash: t -> string

val of_yojson : Yojson.Safe.json -> (t, string) Result.result

val to_yojson : t -> Yojson.Safe.json
