utxoin="dd8d0f904e028c5382c1207897e0c16b91825da821c0a48d5692c1b45fd09155#3"
address=$(cat ak_commonconditions.addr) 
output="450000000"
PREVIEW="--testnet-magic 2"


cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-out $address+$output \
  --tx-out-datum-hash-file \
  --change-address $Adr11 \
  --out-file giveCC.unsigned

cardano-cli transaction sign \
    --tx-body-file giveCC.unsigned \
    --signing-key-file ../../../Wallets/Adr11.skey \
    $PREVIEW \
    --out-file giveCC.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file giveCC.signed