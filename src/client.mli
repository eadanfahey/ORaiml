open Core

(* Get the balance of each person on the blockchain *)
val balances: Blockchain.t -> float String.Map.t

(* Create a transaction sending a given amount of coins from one person to another *)
val send: Blockchain.t -> sender:string -> recipient:string -> amount:float ->
  (Transaction.t, string) result
