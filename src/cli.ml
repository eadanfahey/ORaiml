open Core

let blockchain_file = Constants.blockchain_file

let print_chain =
  Command.basic_spec ~summary:"Print the blockchain"
    Command.Spec.empty
    (fun () ->
       Blockchain.from_file blockchain_file
       |>Blockchain.to_yojson
       |> Yojson.Safe.pretty_to_string
       |> print_string
    )


let new_chain =
  Command.basic_spec ~summary:"Create a new blockchain"
    Command.Spec.empty
    (fun () -> Blockchain.(to_file empty blockchain_file))


let add_block =
  Command.basic_spec ~summary:"Add a block to the blockchain"
    Command.Spec.(
      empty
      +> flag "--data" (required string) ~doc:"The block data"
    )
    (fun data () ->
       let open Blockchain in
       let bc = from_file blockchain_file in
       let block = match to_list bc with
         | [] -> Block.mine ~data:data ~prevhash:None
         | hd :: _ -> Block.(mine ~data:data ~prevhash:(Some (hash hd))) in
       match add_block bc block with
       | Ok bc ->
         to_file bc blockchain_file;
         printf "Added block with hash %s" (Block.hash block)
       | Error e -> failwith e
    )


let command =
  Command.group ~summary:"Interact with the blockchain"
    ["print", print_chain; "new", new_chain; "add-block", add_block]


let () = Command.run command
