use aiken/list
use aiken/transaction.{
  InlineDatum, Input, Output, ScriptContext, Transaction,
} as tx
use utils
use aiken/transaction/value.{Value} as value
use types.{PolicyId, VerificationKeyHash, TokenName}

// Faucet Parameters

// This is a parametized contract,
// that means that you can specify an access token and a token to withdraw.
type FaucetParams {
  access_token_symbol: PolicyId,
  faucet_token_symbol: PolicyId,
}

// Later used to verify that the spender sets the correct name and ammount output.
type FaucetDatum {
  withdrawal_amount: Int,
  faucet_token_name: TokenName,
}

type FaucetRedeemer {
  sender_pkh: VerificationKeyHash,
  access_token_name: TokenName,
}

validator(faucet_params: FaucetParams) {
  fn treasury(dat: FaucetDatum, rdm: FaucetRedeemer, ctx: ScriptContext) -> Bool {
    // Get transaction information from the script-context.
    let ScriptContext { transaction, .. } = ctx
    // Get a list of tokens's policy's from all the inputs.
    let all_tokens: List<PolicyId> =
      utils.inputs_value(transaction.inputs) |> value.policies()
    // Check if the transaction input has a access token.
    let input_has_access_token: Bool =
      list.has(all_tokens, faucet_params.access_token_symbol)

    // Get value paid to the receiver.
    let Transaction { outputs, .. } = transaction
    let value_to_receiver: Value = utils.value_paid_to(outputs, rdm.sender_pkh)

    // Check if the output has the access token
    let output_has_access_token: Bool =
      value.quantity_of(
        value_to_receiver,
        faucet_params.access_token_symbol,
        rdm.access_token_name,
      ) >= 1

    // Check if the output has the faucet token 
    let output_has_faucet_token: Bool =
      value.quantity_of(
        value_to_receiver,
        faucet_params.faucet_token_symbol,
        dat.faucet_token_name,
      ) >= dat.withdrawal_amount

    // Find inputs from this script address
    let own_input: Input = utils.find_own_input(ctx)

    // Find outputs to this script address
    expect [own_output] = utils.find_own_outputs(ctx)

    // Get the value that comes from the faucet.
    let faucet_input_value: Value = utils.inputs_value([own_input])

    // Get the value that come to the faucet
    let faucet_output_value: Value = utils.outputs_value([own_output])

    // This ensures that the spender returns the rest to the funds to the contract again.
    // Current locked amount - withdrawal amount = New locked amount. 
    let faucet_contract_gets_remaining_tokens: Bool =
      value.quantity_of(
        faucet_input_value,
        faucet_params.faucet_token_symbol,
        dat.faucet_token_name,
      ) - dat.withdrawal_amount <= value.quantity_of(
        faucet_output_value,
        faucet_params.faucet_token_symbol,
        dat.faucet_token_name,
      )

    // Expect an inline datum from the output to this contract.
    expect InlineDatum(data) = own_output.datum
    // Then expect that has FaucetDatum type
    expect out_datum: FaucetDatum = data

    // Checks that the new datum in the contract is equal to the previous datum.
    let check_datum: Bool = out_datum == dat

    // The 5 conditions of the spending validator
    and {
      input_has_access_token,
      output_has_access_token,
      output_has_faucet_token,
      faucet_contract_gets_remaining_tokens,
      check_datum,
    }
  }
}
