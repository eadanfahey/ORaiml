open Bignum

let pow_difficulty = 12

let pow_target =
  let i = Bigint.of_int (256 - pow_difficulty) in
  let two = Bigint.of_int 2 in
  Bigint.pow two i
