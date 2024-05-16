
use aiken/transaction/credential.{from_script}
use aiken/transaction.{ScriptContext,Transaction, Input,Output,OutputReference,TransactionId, NoDatum} 
use types.{POSIXtime,VerificationKeyHash}
use aiken/transaction/value.{PolicyId,from_asset,AssetName, ada_asset_name,ada_policy_id,from_asset_list}
use aiken/list
use utils
use aiken/interval.{Finite, Interval,IntervalBound, NegativeInfinity}


//Requirements for Step 2. Valdiator to ensure both sides of the transaction (Company_A and User1) are 
//sending each other the correct amount, the corect tokens (ada for LT), it is before a certain time
// and that the correct people are signing to prevent Bad Bob for manipulating contract
//1. Make sure the user and the company are signing the transaction (multisig)
//2. Make sure the transaction is performed before a certain deadline
//3. Make sure they are the correct tokens 
//4. Make sure the ratio (ada:LT) is correct in the transation 
//both 3 and 4 are performed in "find_token_ratio" function
type RequirementDatum {
    deadline: POSIXtime,
    company_pkh: VerificationKeyHash,
    user_pkh: VerificationKeyHash,
    lt_policyid: PolicyId,
    lt_assetname: AssetName   
}
//{"constructor":0,fields[{"int": 1717795880000},
//       {"bytes": "c32b8657a48213b56cdcbbd22d373e77a76394c9a0bfd098bb72d8f1"},
//       {"bytes": "2294779f65f35b4c16da0225138a537aadc3aa6d0316c0b3c32554a3"},
//       {"bytes": "0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37"},
//       {"bytes": "4c6f79616c747920546f6b656e"}]}


type TestRedeemer {
   pkh : VerificationKeyHash,
   tokename : ByteArray
}

validator{
    fn price_requirement(datum: RequirementDatum, _redeemer: TestRedeemer, ctx: ScriptContext) -> Bool {
         let ScriptContext {transaction, .. } = ctx 
         let Transaction { inputs, .. } = transaction 

         //ensure both people are signing transaction
         let signed = signed_by_both_parties(transaction,datum.company_pkh,datum.user_pkh)

         //check that time has not passed the deadline
         let time_check = utils.must_complete_before(ctx.transaction.validity_range,datum.deadline)
       
         //check to make sure the amount of ada and the amount of LT tokens are equivalent to a 10:1 ratio
         //let token_ratio = find_token_ratio(inputs,datum.lt_policyid,datum.lt_assetname)
         let token_ratio = find_token_ratio(inputs,datum.lt_policyid,datum.lt_assetname)

         signed && time_check && token_ratio
    }
}

fn signed_by_both_parties(transaction: Transaction, c_pkh: VerificationKeyHash, u_pkh: VerificationKeyHash) -> Bool{
      let signed_c = utils.must_be_signed_by(transaction,c_pkh)
      let signed_u = utils.must_be_signed_by(transaction,u_pkh)
      signed_u && signed_c
}


fn find_token_ratio(inputs: List<Input>, pid: PolicyId, an: AssetName) -> Bool {
   //get the value of total ada in the inputs with this function from my utils lib
   //let num_ada: Int = utils.inputs_int(inputs)
   let num_ada: Int = utils.inputs_value_filter(inputs,ada_policy_id,ada_asset_name)
   let num_lt: Int = utils.inputs_value_filter(inputs,pid,an)
   (num_ada/10) >= num_lt
}


// fn find_owner_of_asset(inputs: List<Input>, policyid: PolicyId, addr: Address) -> Bool {
//   list.any(inputs, fn(input) {find_owner(input,policyid,addr)} )
// }


// fn find_owner(input: Input, policyid: PolicyId, addr: Address) -> Bool {
//    //find if the input has the correct policy ID for the LT token   
//    let matchPolicyId = match_policy_id(input,policyid)  
//    //find if the PKH of the input matches that of the provided
//    //in this case it's company A
//    let address_equiv: Bool = input.output.address == addr
//    matchPolicyId && address_equiv 
// }

// fn match_policy_id(input: Input,policyid: PolicyId) -> Bool {
//    expect [(pid,_,_)] = value.flatten(input.output.value)
//    pid == policyid
// }

// fn get_vkh_from_address(addr: Address) -> VerificationKeyHash {
//    when addr.payment_credential is {
//     VerificationKeyCredential(vc) -> vc
//     ScriptCredential(sc) ->  sc
//    }
// }



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
   let p_lt: PolicyId = #"0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37"
   let a_lt: AssetName = "4c6f79616c747920546f6b656e"
   let i_lt = mk_input(1,p_lt,a_lt)
   let list_lt = list.repeat(i_lt,3)

   let p_ada: PolicyId = ada_policy_id
   let a_ada: AssetName = ada_asset_name
   let i_ada = mk_input(1,p_ada,a_ada)
   let list_ada = list.repeat(i_ada,30)

   let list_tot = list.concat(list_lt,list_ada)
   find_token_ratio(list_tot,p_lt,a_lt)   
}

test find_token_ratio_test1() {
   let p_lt: PolicyId = #"0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37"
   let a_lt: AssetName = "4c6f79616c747920546f6b656e"
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
   let p_lt: PolicyId = #"0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37"
   let a_lt: AssetName = "4c6f79616c747920546f6b656e"
   let i_lt = mk_input(3,p_lt,a_lt)
   let list_lt = list.repeat(i_lt,3)

   let p_ada: PolicyId = ada_policy_id
   let a_ada: AssetName = ada_asset_name
   let i_ada = mk_input(3,p_ada,a_ada)
   let list_ada = list.repeat(i_ada,29)

   let list_tot = list.concat(list_lt,list_ada)
   find_token_ratio(list_tot,p_lt,a_lt)   
}

test find_token_ratio_test3() {
   let p_lt: PolicyId = #"0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37"
   let a_lt: AssetName = "4c6f79616c747920546f6b656e"
   let i_lt = mk_input_fromListOfValue(3,p_lt,a_lt,100)
  
   let list_tot = [i_lt]
   find_token_ratio(list_tot,p_lt,a_lt)   
}

test find_token_ratio_test4() fail {
   let p_lt: PolicyId = #"0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37"
   let a_lt: AssetName = "4c6f79616c747920546f6b656e"
   let i_lt = mk_input_fromListOfValue(3,p_lt,a_lt,10)
  
   let list_tot = [i_lt]
   find_token_ratio(list_tot,p_lt,a_lt)   
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
   utils.must_complete_before(i,num + 1)
}

test must_complete_before_test_fail1() fail {
   let num: Int = 10
   let i: Interval<POSIXtime> = Interval 
   { lower_bound:
      IntervalBound { bound_type: NegativeInfinity, is_inclusive: False }
   , upper_bound:
      IntervalBound { bound_type: Finite(num), is_inclusive: False }
   }
   utils.must_complete_before(i,num)
}

test must_complete_before_test_fail2() fail {
   let num: Int = 10
   let i: Interval<POSIXtime> = Interval 
   { lower_bound:
      IntervalBound { bound_type: NegativeInfinity, is_inclusive: False }
   , upper_bound:
      IntervalBound { bound_type: Finite(num), is_inclusive: False }
   }
   utils.must_complete_before(i,num-2)
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


fn mk_input_fromListOfValue(value_na: Int,p: PolicyId, a: AssetName, value_ada: Int) -> Input {
   let ls = [(ada_policy_id, [(ada_asset_name, value_ada)]), (p, [(a, value_na)])]   
   let val = from_asset_list(ls)
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


