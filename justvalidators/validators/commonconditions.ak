use aiken/hash.{Blake2b_224, Hash}
use aiken/interval.{Finite}
use aiken/list
use aiken/transaction.{ScriptContext, Transaction, ValidityRange}
use aiken/transaction/credential.{VerificationKey}

type ConditionsDatum {
  deadline: POSIXtime,
  owner: VerificationKeyHash,
  price: Int,
}

type VerificationKeyHash =
  Hash<Blake2b_224, VerificationKey>

type POSIXtime =
  Int

type ActionRedeemer {
  Owner
  Time
}

type OurWonderfullDatum {
  owd: Int,
}

type OurWonderfullRedeemer {
  owr: Int,
}

validator {
  fn ourWonderfullValidator(
    datum: OurWonderfullDatum,
    redeemer: OurWonderfullRedeemer,
    _context: Data,
  ) -> Bool {
    datum.owd == redeemer.owr
  }
}

validator {
  fn conditionator(
    datum: ConditionsDatum,
    redeemer: ActionRedeemer,
    ctx: ScriptContext,
  ) -> Bool {
    when redeemer is {
      Owner -> must_be_signed_by(ctx.transaction, datum.owner)
      Time -> must_start_after(ctx.transaction.validity_range, datum.deadline)
    }
  }
}

fn must_be_signed_by(transaction: Transaction, vk: VerificationKeyHash) {
  list.has(transaction.extra_signatories, vk)
}

fn must_start_after(range: ValidityRange, lock_expiration_time: POSIXtime) {
  when range.lower_bound.bound_type is {
    Finite(tx_earliest_time) -> lock_expiration_time <= tx_earliest_time
    _ -> False
  }
}
// test signedByMe() {
//   let tx = Transaction
//   {
//     extra_signatories
//     list
//     [#"2070f8488dd696b78a5f23e38d273550e43660526c4b19cba733b488"]
//   }

//   must_be_signed_by(
//     tx,
//     #"2070f8488dd696b78a5f23e38d273550e43660526c4b19cba733b488",
//   )
// }
// test rightonTime(tx: Transaction) {
//   let tx = Transaction(
//     validity_range = ValidityRange(
//       lower_bound = Finite(10),
//       upper_bound = Infinite
//     )
//   )
//   must_start_after(tx.validity_range, 10)
// }

// Type MyType{
//   MyNumber{number: Int}
//   MyBool{yesorno: Bool}
//   MyUnit{myUnit: Void}
//} 
