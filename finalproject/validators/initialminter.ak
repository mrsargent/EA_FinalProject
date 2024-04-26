use aiken/transaction.{ScriptContext} as tx
use utils
use types.{company_a_pkh}




validator{
    fn initialmint(_redeemer:Data, ctx: ScriptContext) -> Bool {
        //check to make sure this is minted by company_a
        utils.must_be_signed_by(ctx.transaction,company_a_pkh) 
    }
}


