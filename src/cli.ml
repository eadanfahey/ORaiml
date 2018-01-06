open Core

let blockchain_file = Constants.blockchain_file
let reward = Constants.reward

let print_chain =
  Command.basic_spec ~summary:"Print the blockchain"
    Command.Spec.empty
    (fun () ->
       Blockchain.from_file blockchain_file
       |> Blockchain.to_yojson
       |> Yojson.Safe.pretty_to_string
       |> print_string
    )

let new_chain =
  Command.basic_spec ~summary:"Create a new blockchain"
    Command.Spec.empty
    (fun () ->
       let open Transaction in
       let output = TXOutput.create ~value:reward ~recipient:"Satoshi" in
       let tx = Coinbase (CoinbaseTX.create ~outputs:[output]) in
       let block = Block.mine ~transactions:[tx] ~prevhash:None in
       match Blockchain.(add_block empty block) with
       | Error e -> failwith e
       | Ok bc ->
         Blockchain.to_file bc blockchain_file;
         printf "Created a new blockchain\n"
    )

let print_balances =
  Command.basic_spec ~summary:"Print the balance of each user"
    Command.Spec.empty
    (fun () ->
       let open Blockchain in
       let bc = from_file blockchain_file in
       let balances = Client.balances bc in
       Map.iteri balances ~f:(fun ~key ~data -> printf "%s: %f\n" key data)
    )

let send =
  let open Result in
  Command.basic_spec ~summary:"Send coins from one user to another"
    Command.Spec.(
      empty
      +> flag "--sender" (required string) ~doc:"The sender of the coins"
      +> flag "--recipient" (required string) ~doc:"The recipient of the coins"
      +> flag "--amount" (required float) ~doc:"The amount of coins to send"
    )
    (fun sender recipient amount () ->
       let open Block in
       let bc = Blockchain.from_file blockchain_file in
       let new_bc = Client.send bc sender recipient amount >>= fun tx ->
         let block = match Blockchain.blocks bc with
           | [] -> mine ~transactions:[tx] ~prevhash:None
           | hd :: _ -> mine ~transactions:[tx] ~prevhash:(Some (hash hd)) in
         Blockchain.add_block bc block
       in
       match new_bc with
       | Error e -> failwith e
       | Ok new_bc ->
         Blockchain.to_file new_bc blockchain_file;
         printf "Sent %f coins from %s to %s\n" amount sender recipient;
    )

let command =
  Command.group ~summary:"Interact with the blockchain"
    ["print", print_chain; "new", new_chain; "balances", print_balances;
     "send", send]

let () = Command.run command
