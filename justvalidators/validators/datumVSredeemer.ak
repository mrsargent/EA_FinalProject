validator {
  fn datumVSredeemer(datum: Int, redeemer: Int, _context: Data) -> Bool {
    redeemer == datum
  }
}
