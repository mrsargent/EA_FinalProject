use aiken/transaction.{ScriptContext, Transaction} 
use aiken/transaction/value.{PolicyId,AssetName}
use utils
use types.{RequirementDatum}

validator{
    fn claim_nft(datum: RequirementDatum, _redeemer: Data, ctx: ScriptContext) -> Bool {
        let ScriptContext {transaction, .. } = ctx 
         let Transaction { inputs, .. } = transaction 

         //check to make sure the tokens are coming from the seller (company_a) and they are the correct 
         //policy id
         let lt_policyid: PolicyId = "00000000000000000" 
         let lt_assetname: AssetName = "LT"         
         let number_of_lt_tokens = utils.inputs_value_filter(inputs,lt_policyid,lt_assetname)
         let valid_number_of_tokens = number_of_lt_tokens >= 10 

         let deadline_not_reached = utils.must_complete_before(ctx.transaction.validity_range, datum.deadline)

         valid_number_of_tokens && deadline_not_reached

    }


}