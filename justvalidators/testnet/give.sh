utxoin="ff2ee97c2c046c2422b7e447352d1982dbd3a346ba61f1318a65534c9bd35aad#4"
address=$(cat ak_typeddatum22.addr) 
output="500000000"
PREVIEW="--testnet-magic 2"


cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-out $address+$output \
  --tx-out-datum-hash-file ./values/value22.json \
  --tx-out $address+$output \
  --tx-out-datum-hash-value 22 \
  --tx-out $address+$output \
  --tx-out-datum-hash-file ./values/customValue22.json \
  --tx-out $Adr11+$output \
  --tx-out $Adr11+$output \
  --tx-out $Adr11+$output \
  --tx-out $Adr11+$output \
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