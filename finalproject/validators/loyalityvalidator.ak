
use aiken/transaction/credential.{Address, VerificationKeyCredential, ScriptCredential,from_script}
use aiken/transaction.{ScriptContext,Transaction, Input,Output,OutputReference,TransactionId, NoDatum} 
use types.{POSIXtime,VerificationKeyHash,company_a_pkh,RequirementDatum}
use aiken/transaction/value.{PolicyId,from_asset,AssetName, ada_asset_name,ada_policy_id}
use aiken/list
use utils.{must_complete_before}
use aiken/interval.{Finite, Interval,IntervalBound, NegativeInfinity}





validator{
    fn price_requirement(datum: RequirementDatum, _redeemer: Data, ctx: ScriptContext) -> Bool {
         let ScriptContext {transaction, .. } = ctx 
         let Transaction { inputs, .. } = transaction 

         //check to make sure the tokens are coming from the seller (company_a) and they are the correct 
         //policy id
         let lt_policyid: PolicyId = "00000000000000000" 
         let lt_assetname: AssetName = "LT"
         let company_address = Address { payment_credential: ScriptCredential(company_a_pkh), stake_credential: None} 
         let owner = find_owner_of_asset(inputs, lt_policyid, company_address)

         //check that time has not passed the deadline
         let time_check = must_complete_before(ctx.transaction.validity_range,datum.deadline)

         //check to make sure the amount of ada and the amount of LT tokens are equivalent to a 10:1 ratio
         let token_ratio = find_token_ratio(inputs,lt_policyid,lt_assetname)

         owner && time_check && token_ratio
    }
}


fn find_token_ratio(inputs: List<Input>, pid: PolicyId, an: AssetName) -> Bool {
   //get the value of total ada in the inputs with this function from my utils lib
   let num_ada: Int = utils.inputs_int(inputs)
   let num_lt: Int = utils.inputs_value_filter(inputs,pid,an)
   num_ada/10 >= num_lt
}


fn find_owner_of_asset(inputs: List<Input>, policyid: PolicyId, addr: Address) -> Bool {
  list.any(inputs, fn(input) {find_owner(input,policyid,addr)} )
}


fn find_owner(input: Input, policyid: PolicyId, addr: Address) -> Bool {
   //find if the input has the correct policy ID for the LT token   
   let matchPolicyId = match_policy_id(input,policyid)  
   //find if the PKH of the input matches that of the provided
   //in this case it's company A
   let address_equiv: Bool = input.output.address == addr
   matchPolicyId && address_equiv 
}

fn match_policy_id(input: Input,policyid: PolicyId) -> Bool {
   expect [(pid,_,_)] = value.flatten(input.output.value)
   pid == policyid
}

fn get_vkh_from_address(addr: Address) -> VerificationKeyHash {
   when addr.payment_credential is {
    VerificationKeyCredential(vc) -> vc
    ScriptCredential(sc) ->  sc
   }
}



//********************************************  test functions for validator and helper functions *****************

//************************** test for validator function "find_token_ratio" ***************************************
test inputs_value_filter_test() {
   let p: PolicyId = "00000000000000000"
   let a: AssetName = "Loyalty Token"
   let i = mk_input(3,p,a)
   let list_i = list.repeat(i,3)
   9 == utils.inputs_value_filter(list_i,p,a)
}

test inputs_value_filter_test1() fail {
   let p: PolicyId = "00000000000000000"
   let a: AssetName = "Loyalty Token"
   let i = mk_input(3,p,a)
   let list_i = list.repeat(i,3)
   10 == utils.inputs_value_filter(list_i,p,a)
}

test find_token_ratio_test() {
   let p_lt: PolicyId = "00000000000000000"
   let a_lt: AssetName = "Loyalty Token"
   let i_lt = mk_input(3,p_lt,a_lt)
   let list_lt = list.repeat(i_lt,3)

   let p_ada: PolicyId = ada_policy_id
   let a_ada: AssetName = ada_asset_name
   let i_ada = mk_input(3,p_ada,a_ada)
   let list_ada = list.repeat(i_ada,30)

   let list_tot = list.concat(list_lt,list_ada)
   find_token_ratio(list_tot,p_lt,a_lt)   
}

test find_token_ratio_test1() {
   let p_lt: PolicyId = "00000000000000000"
   let a_lt: AssetName = "Loyalty Token"
   let i_lt = mk_input(3,p_lt,a_lt)
   let list_lt = list.repeat(i_lt,3)

   let p_ada: PolicyId = ada_policy_id
   let a_ada: AssetName = ada_asset_name
   let i_ada = mk_input(3,p_ada,a_ada)
   let list_ada = list.repeat(i_ada,33)

   let list_tot = list.concat(list_lt,list_ada)
   find_token_ratio(list_tot,p_lt,a_lt)   
}

test find_token_ratio_test2() fail {
   let p_lt: PolicyId = "00000000000000000"
   let a_lt: AssetName = "Loyalty Token"
   let i_lt = mk_input(3,p_lt,a_lt)
   let list_lt = list.repeat(i_lt,3)

   let p_ada: PolicyId = ada_policy_id
   let a_ada: AssetName = ada_asset_name
   let i_ada = mk_input(3,p_ada,a_ada)
   let list_ada = list.repeat(i_ada,29)

   let list_tot = list.concat(list_lt,list_ada)
   find_token_ratio(list_tot,p_lt,a_lt)   
}

// *********************** test for matching polciy ID with provided adress.  not direcly used in validator *******************
//const test_address: VerificationKey = "addr_test1vrpjhpjh5jpp8dtvmjaaytfh8em6wcu5exstl5ychded3ugznvwe3"
const test_vkh: VerificationKeyHash = #"c32b8657a48213b56cdcbbd22d373e77a76394c9a0bfd098bb72d8f1"

test get_vk_from_address_test() {
   let t_addr = Address { payment_credential: ScriptCredential(test_vkh), stake_credential: None} 
   test_vkh == get_vkh_from_address(t_addr)
}

test match_policy_id_test() {
   let p: PolicyId = "00000000000000000"
   let a: AssetName = "Loyalty Token"
   let i: Input = mk_input(100,p,a)
   match_policy_id(i,p)
}

//*********************** test "must_complete_before" function to make sure deadline has not been reach *********************
test must_complete_before_test_pass() {
   let num: Int = 10
   let i: Interval<POSIXtime> = Interval 
   { lower_bound:
      IntervalBound { bound_type: NegativeInfinity, is_inclusive: False }
   , upper_bound:
      IntervalBound { bound_type: Finite(num), is_inclusive: False }
   }
   must_complete_before(i,num + 1)
}

test must_complete_before_test_fail1() fail {
   let num: Int = 10
   let i: Interval<POSIXtime> = Interval 
   { lower_bound:
      IntervalBound { bound_type: NegativeInfinity, is_inclusive: False }
   , upper_bound:
      IntervalBound { bound_type: Finite(num), is_inclusive: False }
   }
   must_complete_before(i,num)
}

test must_complete_before_test_fail2() fail {
   let num: Int = 10
   let i: Interval<POSIXtime> = Interval 
   { lower_bound:
      IntervalBound { bound_type: NegativeInfinity, is_inclusive: False }
   , upper_bound:
      IntervalBound { bound_type: Finite(num), is_inclusive: False }
   }
   must_complete_before(i,num-2)
}


//*********************************helper test functions *******************************************************88
fn mk_output_reference() -> OutputReference {
  OutputReference {transaction_id: TransactionId(""), output_index: 0}
}

fn mk_input(value: Int,p: PolicyId, a: AssetName) -> Input {
   let val = from_asset(p,a,value)
   let output = Output {address: from_script(""), value: val, datum: NoDatum, reference_script: None}
   Input { output_reference: mk_output_reference(), output: output}
}


// fn mk_price_redeemer (v: Int) -> ConditionsRedeemer {
//   ConditionsRedeemer {action: Price, deadline: 0, owner: "", price: v}
// }

// fn mk_output_reference() -> OutputReference {
//   OutputReference {transaction_id: TransactionId(""), output_index: 0}
// }

// fn mk_input(value: Int) -> Input {
//   let output = Output {address: from_script(""), value: value.from_lovelace(value), datum: NoDatum, reference_script: None}
//   Input { output_reference: mk_output_reference(), output: output}
// }

// fn mk_transaction(fee: Int) -> Transaction {
//   transaction.placeholder() |> fn (t) {Transaction { ..t, fee: value.from_lovelace(fee)}}
// }

// fn add_value(p: Transaction, value: Int) -> Transaction {
//   let i = mk_input(value)
//   Transaction { ..p, inputs: [i, ..p.inputs]}
// }

// fn mk_context(t: Transaction) -> ScriptContext {
//   let purpose = Spend( mk_output_reference())
//   ScriptContext {purpose: purpose, transaction: t}
// }


