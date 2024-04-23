<<<<<<< HEAD
utxoin="2d696a4c8dc99b8e711f25853d6221065e7e653db7c0e1263bb990cd1933f427#0"
address=$(cat ak_typeddatum22.addr) 
output="500000000"
PREVIEW="--testnet-magic 2"

=======
utxoin="fbd6423cd06e5aca9d9b1eca1da07e2b276c1b8d388ccf4ed0152ecea7aa8f86#1"
address=$(cat ak_handsonNo1r.addr) 
output="110000000"
>>>>>>> e2b3f5022b600540d37b444daca81589d9571567

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