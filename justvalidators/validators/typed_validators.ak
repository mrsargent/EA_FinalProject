validator {
  fn typeddatum22(datum: Int, _redeemer: Data, _context: Data) -> Bool {
    datum == 22
  }
}

validator {
  fn typedRedeemer11(_datum: Data, redeemer: Int, _context: Data) -> Bool {
    redeemer == 11
  }
}

validator {
  fn datumVSredeemer(datum: Int, redeemer: Int, _context: Data) -> Bool {
    redeemer == datum
  }
}
