use aiken/transaction.{ScriptContext, Transaction,Mint,OutputReference} 
use aiken/transaction/value.{PolicyId,from_minted_value,tokens}
use utils
use aiken/dict
use aiken/list

//Requirements for Step 4.  If user has 10 or more Loyal Tokens (LT) then they can claim (mint)
//a special NFT.
// 1. The user claiming the NFT must have 10 or more tokens
// 2. Must check to make sure the NFT as the correct value
//          a. it must have a qty of 1
//          b. it must have the appropriate assent name
//          c. must have a valid utxo 
// *** decided that siginig is not required as anyone with these tokens are able to mint
validator(utxo_ref: OutputReference, nft_asset_name: ByteArray, lt_assetname: ByteArray  ,lt_policyid: PolicyId){
    fn claim_nft(_redeemer: Data, ctx: ScriptContext) -> Bool {
        let ScriptContext {transaction, purpose } = ctx 
        let Transaction { inputs, .. } = transaction         

         //check to make sure the tokens are coming from the seller (company_a) and they are the correct 
         //policy id             
        let number_of_lt_tokens = utils.inputs_value_filter(inputs,lt_policyid, lt_assetname)
        let valid_number_of_tokens = number_of_lt_tokens >= 10 

        //check to make sure there is a valid utxo and that there is only 1 with the correct asset name
        expect Mint(policyid) = purpose 
        let only_one_valid_nft = there_can_only_be_one_nft(transaction,utxo_ref,policyid, nft_asset_name)

         valid_number_of_tokens && only_one_valid_nft
    }
}


fn there_can_only_be_one_nft(transaction: Transaction, utxo_ref: OutputReference, pid: PolicyId, asset_name: ByteArray){
    //check to make sure there is a valid utxo in the list of out_refs
    let utxo_exists = list.any(transaction.inputs, fn(input){input.output_reference == utxo_ref})

    //make only 1 nft will be minted with the proper asset_name
    let mint = transaction.mint   
    expect [(an, qty)] = 
        mint 
            |> from_minted_value
            |> tokens(pid)
            |> dict.to_list
    let correct_nft_values = qty == 1
    let correct_asset_name = asset_name == an
    
    correct_nft_values && correct_asset_name && utxo_exists

}