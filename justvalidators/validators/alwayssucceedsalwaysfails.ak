validator {
  fn alwaysSucceeds(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    True
  }
}

validator {
  fn alwaysFails(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    False
  }
}
