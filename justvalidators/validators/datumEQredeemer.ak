validator {
  fn datumEQredeemer(datum: Int, redeemer: Int, _context: Data) -> Bool {
    redeemer == datum
  }
}
