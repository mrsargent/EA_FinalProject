use aiken/hash.{Blake2b_224, Hash}
use aiken/interval.{Finite}
use aiken/list
use aiken/transaction.{ScriptContext, Transaction, ValidityRange}
use aiken/transaction/credential.{VerificationKey}

type ConditionsDatum {
  lock_until: POSIXTime,
  owner: VerificationKeyHash,
  price: Int,
}

type VerificationKeyHash =
  Hash<Blake2b_224, VerificationKey>

type POSIXTime =
  Int

validator {
  fn conditionator(datum: ConditionsDatum, redeemer: Int, ctx: ScriptContext) {
    when redeemer is {
      1 -> must_be_signed_by(ctx.transaction, datum.owner)
      2 -> must_start_after(ctx.transaction.validity_range, datum.lock_until)
      _ -> False
    }
  }
}

fn must_be_signed_by(transaction: Transaction, vk: VerificationKeyHash) {
  list.has(transaction.extra_signatories, vk)
}

fn must_start_after(range: ValidityRange, lock_expiration_time: POSIXTime) {
  when range.lower_bound.bound_type is {
    Finite(tx_earliest_time) -> lock_expiration_time <= tx_earliest_time
    _ -> False
  }
}
