use aiken/transaction.{ScriptContext, Transaction, ValidityRange}

validator {
    fn (datum: Int, redeemer: Int, ctx: ScriptContext){
            datum == redeemer || redeemer == 11
    }
}



