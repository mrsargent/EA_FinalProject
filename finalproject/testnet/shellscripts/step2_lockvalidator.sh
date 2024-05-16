utxoin_companya="a13af8f4ccecf0d268c8017c94b22c648b50ef82bdac1ac2db96a35d8d7854f9#0"
utxoin_user="e5bb10a20d7223073ebc53820839606b8e905f0678e9d532541accd9c0ae51c3#2"
address="addr_test1wqkahdh00s3xw94nkhfgh2dr8nq0h7tn2dh8wrmajp4pmjscsse75" #address of loyalityvalidator.addr
address_test="addr_test1wqkahdh00s3xw94nkhfgh2dr8nq0h7tn2dh8wrmajp4pmjscsse75"
output_company="125000030"
tokenamount="10"
remaindertoken="9990"
output_user="5000000"
changeAddress="addr_test1vrpjhpjh5jpp8dtvmjaaytfh8em6wcu5exstl5ychded3ugznvwe3" #company_a address
company_a_signerPKH="c32b8657a48213b56cdcbbd22d373e77a76394c9a0bfd098bb72d8f1"  
PREVIEW="--testnet-magic 2"
tokenname="4c6f79616c747920546f6b656e"
policyid="0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37"
collateral="2bbd4fd5b1e8f80f730d2bf2744983910d2b5a1650ffc49f388a4a39dd4b0c0d#2"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin_companya \
  --tx-in $utxoin_user \
  --tx-in-collateral $collateral \
  --tx-out $address_test+$output_company+"$tokenamount $policyid.$tokenname" \
  --tx-out-datum-hash-file ./../values/requirement_datum.json \
  --tx-out $changeAddress+$output_user+"$remaindertoken $policyid.$tokenname" \
  --change-address $changeAddress \
  --protocol-params-file protocol.params \
  --out-file step2lock.unsigned

cardano-cli transaction sign \
    --tx-body-file step2lock.unsigned \
    --signing-key-file ./../../Wallet/CompanyA.skey \
    --signing-key-file ./../../Wallet/User1.skey \
    $PREVIEW \
    --out-file step2lock.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file step2lock.signed


  


  # cardano-cli transaction build \
  # --babbage-era \
  # $PREVIEW \
  # --tx-in $utxoin_companya \
  # --tx-in-collateral $collateral \
  # --tx-out $address_test+$output_company \
  # --tx-out-datum-hash-file ./../values/requirement_datum.json \
  # --change-address $changeAddress \
  # --protocol-params-file protocol.params \
  # --out-file step2lock.unsigned