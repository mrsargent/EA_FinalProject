
use aiken/transaction/credential.{Address, VerificationKeyCredential, ScriptCredential,from_script}
use aiken/transaction.{ScriptContext,Transaction, Input,Output,OutputReference,TransactionId, NoDatum} 
use types.{POSIXtime,VerificationKeyHash,company_a_pkh}
use aiken/transaction/value.{PolicyId,from_asset,flatten,quantity_of,AssetName}
use aiken/list
use utils.{must_complete_before}
use aiken/interval.{Finite, Interval,IntervalBound, NegativeInfinity}



type RequirementDatum {
    deadline: POSIXtime,
    someshit: Int

}

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
   let num_lt: Int = inputs_value_filter(inputs,pid,an)
   num_ada/10 == num_lt
}


fn inputs_value_filter(inputs: List<Input>, pid: PolicyId,an: AssetName) -> Int {
   //filter the inputs by policy id
  let filtered_inputs: List<Input> = list.filter(inputs, fn(input) {filter_policyid(input,pid)})
  let totaled_value = utils.inputs_value(filtered_inputs)
  quantity_of(totaled_value,pid, an)
}

fn filter_policyid(input: Input, policyid: PolicyId) -> Bool {
  expect [(pid,_,_)] = flatten(input.output.value)
  pid == policyid
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



//********************************************  test functions ****************************************************************8 

//const test_address: VerificationKey = "addr_test1vrpjhpjh5jpp8dtvmjaaytfh8em6wcu5exstl5ychded3ugznvwe3"
const test_vkh: VerificationKeyHash = #"c32b8657a48213b56cdcbbd22d373e77a76394c9a0bfd098bb72d8f1"

test get_vk_from_address_test() {
   let t_addr = Address { payment_credential: ScriptCredential(test_vkh), stake_credential: None} 
   test_vkh == get_vkh_from_address(t_addr)
}

test match_policy_id_test() {
   let p: PolicyId = "00000000000000000"
   let i: Input = mk_input(100,p)
   match_policy_id(i,p)
}

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


//helper test functions
fn mk_output_reference() -> OutputReference {
  OutputReference {transaction_id: TransactionId(""), output_index: 0}
}

fn mk_input(value: Int,p: PolicyId) -> Input {
   let val = from_asset(p,"Loyalty Token",value)
   let output = Output {address: from_script(""), value: val, datum: NoDatum, reference_script: None}
   Input { output_reference: mk_output_reference(), output: output}
}

