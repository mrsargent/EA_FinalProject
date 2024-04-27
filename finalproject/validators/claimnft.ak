use aiken/transaction.{ScriptContext, Transaction,Mint} 
use aiken/transaction/value.{PolicyId,AssetName,from_minted_value,tokens}
use utils
use types.{RequirementDatum}
use aiken/dict

validator{
    fn claim_nft(datum: RequirementDatum, _redeemer: Data, ctx: ScriptContext) -> Bool {
        let ScriptContext {transaction, purpose } = ctx 
         let Transaction { inputs, mint, .. } = transaction         

         //check to make sure the tokens are coming from the seller (company_a) and they are the correct 
         //policy id
         let lt_policyid: PolicyId = "00000000000000000" 
         let lt_assetname: AssetName = "LT"         
         let number_of_lt_tokens = utils.inputs_value_filter(inputs,lt_policyid,lt_assetname)
         let valid_number_of_tokens = number_of_lt_tokens >= 10 

        //make sure deadline has not been reached
         let deadline_not_reached = utils.must_complete_before(ctx.transaction.validity_range, datum.deadline)

        //make sure only 1 amt of NFT is being minted 
        expect Mint(policyid) = purpose 
        expect [(_, amt)] = 
            mint 
                |> from_minted_value
                |> tokens(policyid)
                |> dict.to_list
        let correct_nft_values = amt ==1

         valid_number_of_tokens && deadline_not_reached && correct_nft_values

    }





}