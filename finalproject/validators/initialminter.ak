use aiken/transaction.{ScriptContext,Mint} 
use aiken/transaction/value.{from_minted_value,tokens}
use aiken/dict 
use utils
//use types.{VerificationKeyHash}

// Requirements for the Step 1. Miniting policy to create the loyal tokens
//1. making sure is created only by Company A
//2. make sure the token name is Loyalty Token
//3. Make sure it is only minting 10000 token at a time
validator(company_pkh: ByteArray, asset_name: ByteArray) {
    fn initialmint(_redeemer:Data, ctx: ScriptContext) -> Bool {
        let ScriptContext {transaction, purpose} = ctx
        //check to make sure this is minted by company_a
        let signed_by_company = utils.must_be_signed_by(transaction,company_pkh) 

        expect Mint(policyid) = purpose

        expect [(an, qty)] = 
            transaction.mint
                |> from_minted_value
                |> tokens(policyid)
                |> dict.to_list()

        let name_correct = asset_name == an 
        let qty_correct = qty == 10000

        signed_by_company && name_correct && qty_correct
    }
}





