utxoin1="7f1409ec3e5861a6371a3b9a10117538177d11d3dbba056254d12b4b14699145#0"
utxoin2="7f1409ec3e5861a6371a3b9a10117538177d11d3dbba056254d12b4b14699145#1"
utxoin3="7f1409ec3e5861a6371a3b9a10117538177d11d3dbba056254d12b4b14699145#2"
utxoin4="7f1409ec3e5861a6371a3b9a10117538177d11d3dbba056254d12b4b14699145#3"
utxoin5="891b6f43d01ebbf22c14c6b034b5cf8e0df1919dfb4ca3d135580e4cab63585b#0"
address="" 
output="900000000"
collateral="e623894e267cf3d4553327108d566d61b01298a1b56363b260ffb5e768578913#0"
signerPKH=$(cat ../../../Wallets/Adr11.pkh)

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin1 \
  --tx-in-script-file ./compiled/ak_handsonNo1r.uplc \
  --tx-in-datum-file ./values/customValue22.json \
  --tx-in-redeemer-file ./values/customValue22.json \
  --tx-in $utxoin2 \
  --tx-in-script-file ./compiled/ak_handsonNo1r.uplc \
  --tx-in-datum-file ./values/True.json \
  --tx-in-redeemer-file ./values/True.json \
  --tx-in $utxoin3 \
  --tx-in-script-file ./compiled/ak_handsonNo1r.uplc \
  --tx-in-datum-file ./values/False.json \
  --tx-in-redeemer-file ./values/False.json \
  --tx-in $utxoin4 \
  --tx-in-script-file ./compiled/ak_handsonNo1r.uplc \
  --tx-in-datum-file ./values/Unit.json \
  --tx-in-redeemer-file ./values/Unit.json \
  --tx-in $utxoin5 \
  --tx-in-script-file ./compiled/ak_handsonNo1r.uplc \
  --tx-in-datum-file ./values/customValue23.json \
  --tx-in-redeemer-file ./values/customValue11.json \
  --required-signer-hash $(cat ../../../Wallets/Adr11.pkh)  \
  --tx-in-collateral "e623894e267cf3d4553327108d566d61b01298a1b56363b260ffb5e768578913#0" \
  --tx-out $Adr11+$output \
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

  
  
 