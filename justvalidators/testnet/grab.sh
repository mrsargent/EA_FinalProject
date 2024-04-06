utxoin="dd8d0f904e028c5382c1207897e0c16b91825da821c0a48d5692c1b45fd09155#1"
address=$(cat ak_typeddatum22.addr) 
output="220000000"
collateral="e623894e267cf3d4553327108d566d61b01298a1b56363b260ffb5e768578913#0"
signerPKH=$(cat ../../../Wallets/Adr11.pkh)dd8d0f904e028c5382c1207897e0c16b91825da821c0a48d5692c1b45fd09155 

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-in-script-file ./compiled/ak_typeddatum22.uplc \
  --tx-in-datum-file ./values/value22.json \
  --tx-in-redeemer-value 0 \
  --required-signer-hash $(cat ../../../Wallets/Adr11.pkh)  \
  --tx-in-collateral e623894e267cf3d4553327108d566d61b01298a1b56363b260ffb5e768578913#0 \
  --tx-out $nami3+$output \
  --change-address $nami3 \
  --out-file grab.unsigned

cardano-cli transaction sign \
    --tx-body-file grab.unsigned \
    --signing-key-file ../../../Wallets/Adr11.skey \
    $PREVIEW \
    --out-file grab.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file grab.signed