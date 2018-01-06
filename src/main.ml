open Core
open Result

let () =
  let open Block in
  let block1 = mine "Infinite Jest" None in
  let block2 = mine "Gravity's Rainbow" (Some (hash block1)) in
  let blockchain = Blockchain.(
      add_block empty block1 >>= fun bc ->
      add_block bc block2
    ) in
  match blockchain with
  | Error e -> failwith e
  | Ok bc   -> Blockchain.to_yojson bc
               |> Yojson.Safe.pretty_to_string
               |> print_string;

  printf "\n\nHash of block1: %s" (hash block1);
