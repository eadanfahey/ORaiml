open Core

type t = Transaction.TXOutput.t list [@@deriving yojson]

let empty = []

let to_list t = t

(* Remove the first occurrence of x from the list l, if it exists.*)
let remove l a =
  let rec helper acc rest =
    match rest with
    | [] -> List.rev acc
    | hd :: tl -> if hd = a then List.rev_append acc tl else helper (hd :: acc) tl
  in
  helper [] l

let update t tx =
  let open Transaction in
  let t = List.append t (outputs tx) in
  match tx with
  | Coinbase _ -> t
  | Standard tx -> (
      let ref_outputs = List.map (StandardTX.inputs tx) ~f:(TXInput.output) in
      List.fold ref_outputs ~init:t ~f:remove
    )

