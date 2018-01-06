type t

val empty: t

val update: t -> Transaction.t -> t

val to_list: t -> Transaction.TXOutput.t list

val of_yojson : Yojson.Safe.json -> (t, string) Result.result

val to_yojson : t -> Yojson.Safe.json
