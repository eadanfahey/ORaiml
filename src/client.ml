open Core

let balances bc =
  let open Transaction in
  let utxo = Utxo.to_list (Blockchain.utxo bc) in
  List.fold utxo ~init:String.Map.empty ~f:(fun acc output ->
      let recipient = TXOutput.recipient output in
      let value = TXOutput.value output in
      let newbal = match Map.find acc recipient with
        | None -> value
        | Some bal -> value +. bal in
      Map.set acc recipient newbal
    )

(* Filter a list of outputs such that their total value is sufficient for
   creating a transaction of given amount *)
let sufficient_outputs txoutputs amount =
  let open Transaction in
  let rec helper acc keep rest =
    match acc >= amount with
    | true -> Some (acc, keep)
    | false -> (match rest with
        | [] -> None
        | hd :: tl -> helper (acc +. TXOutput.value hd) (hd :: keep) tl
      )
  in
  helper 0.0 [] txoutputs

let send bc ~sender ~recipient ~amount =
  let open Transaction in
  let sender_outputs =
    Blockchain.utxo bc
    |> Utxo.to_list
    |> List.filter ~f:(fun output -> TXOutput.recipient output = sender) in
  match sufficient_outputs sender_outputs amount with
  | None ->
    Error (sprintf "%s has insufficient funds" sender)
  | Some (total_amount, ref_outputs) -> (
      let new_inputs = List.map ref_outputs ~f:(
          fun out -> TXInput.create out sender) in
      let new_outputs = [
        TXOutput.create amount recipient;
        TXOutput.create (total_amount -. amount) sender
      ] in
      Ok (Standard (StandardTX.create new_inputs new_outputs))
    )
