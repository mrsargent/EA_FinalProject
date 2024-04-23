use aiken/hash.{Blake2b_224, Hash}

// Type synonims.

pub type TokenName =
  ByteArray

pub type VerificationKey =
  ByteArray

pub type Script =
  ByteArray

pub type PolicyId =
  Hash<Blake2b_224, Script>

pub type PublicKeyHash =
  Hash<Blake2b_224, VerificationKey>
