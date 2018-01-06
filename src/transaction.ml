open Core

module TXOutput = struct
  type t = {
    value: float;
    recipient: string
  } [@@deriving yojson]
  let create ~value ~recipient = {value; recipient}
  let value t = t.value
  let recipient t = t.recipient
end

module TXInput = struct
  type t = {
    output: TXOutput.t;
    sender: string
  } [@@deriving yojson]
  let create ~output ~sender = {output; sender}
  let output t = t.output
  let sender t = t.sender
end

module StandardTX = struct
  type t = {
    inputs: TXInput.t list;
    outputs: TXOutput.t list;
  } [@@deriving yojson]
  let create ~inputs ~outputs = {inputs; outputs}
  let inputs t = t.inputs
  let outputs t = t.outputs
end

module CoinbaseTX = struct
  type t = {
    outputs: TXOutput.t list
  } [@@deriving yojson]
  let create ~outputs = {outputs}
  let outputs t = t.outputs
end

type t =
  | Standard of StandardTX.t
  | Coinbase of CoinbaseTX.t
  [@@deriving yojson]

let outputs = function
  | Standard tx -> StandardTX.outputs tx
  | Coinbase tx -> CoinbaseTX.outputs tx
