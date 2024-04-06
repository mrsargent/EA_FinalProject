type Mydatum {
  mydatum: Int,
}

validator {
  fn datum22(datum: Data, _redeemer: Data, _context: Data) -> Bool {
    expect thedatum: Mydatum = datum
    thedatum.mydatum == 22
  }
}

type MyRedeemer {
  myredeemer: Int,
}

validator {
  fn redeemer11(_datum: Data, redeemer: Data, _context: Data) -> Bool {
    expect theredeemer: MyRedeemer = redeemer
    theredeemer.myredeemer == 11
  }
}

validator {
  fn datumVSredeemer(datum: Data, redeemer: Data, _context: Data) -> Bool {
    redeemer == datum
  }
}
