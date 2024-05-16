utxoin_contract_company_LT="cb832e77f5bfed9f73813e797f35c7114a4770f2ebcfd2ea0bcd67a7a99a5720#0"  #utxo with LT tokens from contrat that company A locked
company_address="addr_test1wzp9dgtgtrcsh3dw4az992ej3kwasxmd6d2x47r3jqrjans39kuwd"
user_address="addr_test1vq3fgaulvhe4knqkmgpz2yu22da2msa2d5p3ds9ncvj4fgcldkaz4"
output_to_company="100000000"
tokenamount="10"
output_to_user="5000000"
company_a_signerPKH="c32b8657a48213b56cdcbbd22d373e77a76394c9a0bfd098bb72d8f1"  
user_pkh="2294779f65f35b4c16da0225138a537aadc3aa6d0316c0b3c32554a3"
PREVIEW="--testnet-magic 2"
tokenname="4c6f79616c747920546f6b656e"
policyid="0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37"
collateral="8c7aa94201eca369c2adcd013c47843ffa0e872bda548e5845b1edce0c11cddc#1"


cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin_contract_company_LT \
  --tx-in-script-file ./../compiled/loyalityvalidator.uplc \
  --tx-in-datum-file ./../values/requirement_datum.json \
  --tx-in-redeemer-file ./../values/test_redeemer.json \
  --required-signer-hash $company_a_signerPKH \
  --required-signer-hash $user_pkh \
  --tx-in-collateral $collateral \
  --tx-out $user_address+$output_to_user+"$tokenamount $policyid.$tokenname" \
  --tx-out $company_address+$output_to_company \
  --change-address $company_address \
  --invalid-hereafter 49233380 \
  --protocol-params-file protocol.params \
  --out-file step3unlock.unsigned

cardano-cli transaction sign \
    --tx-body-file step3unlock.unsigned \
    --signing-key-file ./../../Wallet/CompanyA.skey \
    --signing-key-file ./../../Wallet/User1.skey \
    $PREVIEW \
    --out-file step3unlock.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file step3unlock.signed




# cardano-cli transaction build \
#   --babbage-era \
#   $PREVIEW \
#   --tx-in $utxoin_contract_company_LT \
#   --tx-in-script-file ./../compiled/loyalityvalidator.uplc \
#   --tx-in-datum-file ./../values/requirement_datum.json \
#   --tx-in-redeemer-file ./../values/test_redeemer.json \
#   --tx-in $utxoin_contract_user_ada \
#   --required-signer-hash $company_a_signerPKH \
#   --required-signer-hash $user_pkh \
#   --tx-in-collateral $collateral \
#   --tx-out $company_address+$output_to_company \
#   --change-address $company_address \
#   --invalid-hereafter 48543790 \
#   --protocol-params-file protocol.params \
#   --out-file step3unlock.unsigned