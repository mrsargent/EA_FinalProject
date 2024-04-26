use aiken/hash.{Blake2b_224, Hash}
use aiken/transaction/credential.{VerificationKey}
//use aiken/transaction/value.{PolicyId}

//constants

pub const company_a_pkh: VerificationKeyHash = #""  // todo *** put pkh here
//pub const lt_policyid: PolicyId = ""  // todo *** put pkh here
//pub const company_a_address: Address = ""  // todo *** put pkh here

// Types

pub type POSIXtime =
  Int


pub type TokenName =
  ByteArray

pub type Script =
  ByteArray

pub type PolicyId =
  Hash<Blake2b_224, Script>

pub type VerificationKeyHash =
  Hash<Blake2b_224, VerificationKey>
