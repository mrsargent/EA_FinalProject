validator {
  fn typedRedeemer11(_datum: Int, redeemer: Data, _context: Data) -> Bool {
    redeemer == 22
  }
}
