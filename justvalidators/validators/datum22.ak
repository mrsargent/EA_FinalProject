type Mydatum {
  mydatum: Int,
}

validator {
  fn datum22(datum: Data, _redeemer: Data, _context: Data) -> Bool {
    expect thedatum: Mydatum = datum
    thedatum.mydatum == 22
  }
}
