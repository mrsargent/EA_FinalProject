# this is the shell commands for the initial mint.  This is when Company A is going to mint 10000 Loyalty Tokens (LTs).
# Company A can mint as many tokens as they want as many times as they want. The only thing that must happen is that 
# company A must sign the transaction.  This prevents unauthorized people from minting

utxoin1="31814e80d9dedb94124370188866e37c542567eeacf6c9bb477b301c81b49224#1"
policyid="0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37" #$(cat ../../compiled/initialmint.pid)
company_a="addr_test1vrpjhpjh5jpp8dtvmjaaytfh8em6wcu5exstl5ychded3ugznvwe3"
output="12000000"
tokenamount="10000"
tokenname="4c6f79616c747920546f6b656e"   #$(echo -n "Loyalty Token" | xxd -ps | tr -d '\n')
collateral_company_a="4af8612f022bf17e33135c88dcdab347afceb5cf1e26db7cdaaeedbb49ad5e59#0" 
company_a_signerPKH="c32b8657a48213b56cdcbbd22d373e77a76394c9a0bfd098bb72d8f1"  
txTimeInterval="--invalid-hereafter 10962786"
PREVIEW="--testnet-magic 2"
mintingScript="./../compiled/initialmint_refparam.json"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin1 \
  --required-signer-hash $company_a_signerPKH \
  --tx-in-collateral $collateral_company_a \
  --tx-out $company_a+$output+"$tokenamount $policyid.$tokenname" \
  --change-address $company_a \
  --mint "$tokenamount $policyid.$tokenname" \
  --mint-script-file $mintingScript \
  --mint-redeemer-file ./../values/empty.json \
  --protocol-params-file protocol.params \
  --out-file initialmint.unsigned

cardano-cli transaction sign \
    --tx-body-file initialmint.unsigned \
    --signing-key-file ./../../Wallet/CompanyA.skey \
    $PREVIEW \
    --out-file initialmint.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file initialmint.signed