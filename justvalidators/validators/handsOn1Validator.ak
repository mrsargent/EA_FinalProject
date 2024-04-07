type MyType {
    Unit
    Number {x: Int}
    YesOrNo {yn: Bool}    
}

validator {
    fn handsOn1 (datum: MyType, redeemer: MyType, _ctx: Data) -> Bool {
            when (datum, redeemer) is {
              (Number(x1), Number(x2))      -> x1 == x2 || x2 == 11
              (YesOrNo(yn1), YesOrNo(yn2))  -> yn1 == yn2 
              (Unit, Unit)                  -> True 
              (_, Number(red2))             -> red2 == 11 
              _                             -> False
            }
    }
}


//hands on 1 version 2

type MyRedeemer {
  red: Int 
}

validator {
  fn handsOn1_2 (datum: Data, redeemer: Data, _ctx:Data) -> Bool {
      if datum == redeemer {
        True
      } else {
          expect theredeemer: MyRedeemer = redeemer
          theredeemer.red == 11 
      }
      
  }
}


//hands on 1 version 3

type T {
  I(Int)
  B(Bool)
  U(Void)
}

validator {
    fn handsOn1_3(datum: Data, redeemer: Data, _context: Data) -> Bool {
        expect myDatum : T = datum
        expect myRedeemer : T = redeemer
        when (myDatum, myRedeemer) is {
            (I(di), I(ri)) -> di == ri
            (B(db), B(rb)) -> db == rb
            (U( _), U( _)) -> True
            _              -> False
        }
    }
}


