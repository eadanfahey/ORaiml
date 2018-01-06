open Core

module TXOutput : sig
  type t
  val create: value:float -> recipient:string -> t
  val value: t -> float
  val recipient: t -> string
  val of_yojson: Yojson.Safe.json -> (t, string) result
  val to_yojson: t -> Yojson.Safe.json
end

module TXInput : sig
  type t
  val create: output:TXOutput.t -> sender:string -> t
  val output: t -> TXOutput.t
  val sender: t -> string
  val of_yojson: Yojson.Safe.json -> (t, string) result
  val to_yojson: t -> Yojson.Safe.json
end

module StandardTX : sig
  type t
  val create: inputs:TXInput.t list -> outputs:TXOutput.t list -> t
  val inputs: t -> TXInput.t list
  val outputs: t -> TXOutput.t list
  val of_yojson: Yojson.Safe.json -> (t, string) result
  val to_yojson: t -> Yojson.Safe.json
end

module CoinbaseTX : sig
  type t
  val create: outputs:TXOutput.t list -> t
  val outputs: t -> TXOutput.t list
  val of_yojson: Yojson.Safe.json -> (t, string) result
  val to_yojson: t -> Yojson.Safe.json
end

type t =
  | Standard of StandardTX.t
  | Coinbase of CoinbaseTX.t

val of_yojson: Yojson.Safe.json -> (t, string) result

val to_yojson: t -> Yojson.Safe.json

val outputs: t -> TXOutput.t list
