type MyRedeemer {
  myredeemer: Int,
}

validator {
  fn redeemer11(_datum: Data, redeemer: Data, _context: Data) -> Bool {
    expect theredeemer: MyRedeemer = redeemer
    theredeemer.myredeemer == 11
  }
}
