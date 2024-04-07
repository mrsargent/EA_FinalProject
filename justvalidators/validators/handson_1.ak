type MyRedeemer {
  red: Int,
}

validator {
  fn handsonNo1(datum: Data, redeemer: Data, _ctx: Data) -> Bool {
    if datum == redeemer {
      True
    } else {
      expect theredeemer: MyRedeemer = redeemer
      theredeemer.red == 11
    }
  }
}

type MyType {
  Unit
  Number { x: Int }
  YesorNo { yn: Bool }
}

validator {
  fn handsNo1r(datum: MyType, redeemer: MyType, _ctx: Data) -> Bool {
    when (datum, redeemer) is {
      (Number(dat1), Number(red2)) -> dat1 == red2 || red2 == 11
      (YesorNo(dat1), YesorNo(red2)) -> dat1 == red2
      (Unit, Unit) -> True
      _ -> False
    }
  }
}
