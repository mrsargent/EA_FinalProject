utxoin="2d696a4c8dc99b8e711f25853d6221065e7e653db7c0e1263bb990cd1933f427#0"
address=$(cat ./compiled/handson1_1.addr) 
output="50000000"
PREVIEW="--testnet-magic 2"


cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-out $address+$output \
  --tx-out-datum-hash-file ./values/customValue22.json \
  --tx-out $address+$output \
  --tx-out-datum-hash-file ./values/True.json \
  --tx-out $address+$output \
  --tx-out-datum-hash-file ./values/False.json \
  --tx-out $address+$output \
  --tx-out-datum-hash-file ./values/Unit.json \
  --change-address $Addr44 \
  --out-file givehandsOn1.unsigned

cardano-cli transaction sign \
    --tx-body-file givehandsOn1.unsigned \
    --signing-key-file ../Wallet/Addr44.skey \
    $PREVIEW \
    --out-file givehandsOn1.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file givehandsOn1.signed