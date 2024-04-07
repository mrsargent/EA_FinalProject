utxoin="fbd6423cd06e5aca9d9b1eca1da07e2b276c1b8d388ccf4ed0152ecea7aa8f86#1"
address=$(cat ak_handsonNo1r.addr) 
output="110000000"

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-out $address+$output \
  --tx-out-datum-hash-file ./values/customValue23.json \
  --change-address $Adr11 \
  --out-file give.unsigned

cardano-cli transaction sign \
    --tx-body-file give.unsigned \
    --signing-key-file ../../../Wallets/Adr11.skey \
    $PREVIEW \
    --out-file give.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file give.signed