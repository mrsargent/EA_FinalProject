
use aiken/dict
use aiken/list
use aiken/transaction.{ScriptContext, Transaction} as tx
use aiken/transaction/value.{Value, flatten, policies}
use types.{PolicyId, TokenName}
use utils

type PolicyParams {
  contributor: PolicyId,
}

validator(params: PolicyParams) {
  fn minter(tn: TokenName, ctx: ScriptContext) -> Bool {
    // Get the relevant data from the script context.
    let ScriptContext { transaction, purpose } = ctx
    expect tx.Mint(policy_id) = purpose
    let Transaction { inputs, mint, .. } = transaction

    // Get total value from inputs.
    let all_input_values: Value = utils.inputs_value(inputs)
    // Get a list of policyids from the inputs.
    let policies: List<PolicyId> = policies(all_input_values)

    // Check if one element of the list corresponds to the contributor token policyid.
    let input_has_contributor_token: Bool =
      list.has(policies, params.contributor)

    // From the minted values expect just one token minted. 
    expect [(minted_asset_name, amount)] =
      mint
        |> value.from_minted_value
        |> value.tokens(policy_id)
        |> dict.to_list()

    // Check if the minted asset has the corresponding name and an amount of 1.
    let check_minted_amount: Bool = minted_asset_name == tn && amount == 1

    // Check that redeemer matches the TokenName of the PPBL2023 Token, without the leading 222.
    let check_token_name: Bool =
      all_input_values
        |> flatten()
        |> list.map(fn(e) { e.2nd })
        |> list.any(fn(e) { utils.comparing(tn, e) })

    // Check if the contract has the contributor token as input, and if it has the corresponding name and amount. 
    input_has_contributor_token && check_minted_amount && check_token_name
  }
}
