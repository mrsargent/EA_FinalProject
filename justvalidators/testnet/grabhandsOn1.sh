utxoin1="d32fb2518e8807444d6ea5d99b3228af225121827f6058779f0d1b91578b2605#0"
utxoin2="d32fb2518e8807444d6ea5d99b3228af225121827f6058779f0d1b91578b2605#1"
utxoin3="d32fb2518e8807444d6ea5d99b3228af225121827f6058779f0d1b91578b2605#2"
utxoin4="d32fb2518e8807444d6ea5d99b3228af225121827f6058779f0d1b91578b2605#3"
script="./compiled/handson1_1.uplc" #$(cat ./compiled/handson1_1.uplc) 
output="10000000"
collateral="701f1c4d6f37020b5f864add11991fa64e100ea4de8fd5e8f24c182af5d82857#0"
signerPKH=$(cat ../Wallet/Addr45.pkh) 
PREVIEW="--testnet-magic 2"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params


cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin1 \
  --tx-in-script-file $script \
  --tx-in-datum-file ./values/customValue22.json \
  --tx-in-redeemer-file ./values/customValue22.json \
  --tx-in $utxoin2 \
  --tx-in-script-file $script \
  --tx-in-datum-file ./values/True.json \
  --tx-in-redeemer-file ./values/True.json \
  --tx-in $utxoin3 \
  --tx-in-script-file $script \
  --tx-in-datum-file ./values/False.json \
  --tx-in-redeemer-file ./values/False.json \
  --tx-in $utxoin4 \
  --tx-in-script-file $script \
  --tx-in-datum-file ./values/Unit.json \
  --tx-in-redeemer-file ./values/Unit.json \
  --required-signer-hash $signerPKH  \
  --tx-in-collateral $collateral \
  --tx-out $Addr44+$output \
  --change-address $Addr44 \
  --protocol-params-file protocol.params \
  --out-file grabhandsOn1.unsigned



cardano-cli transaction sign \
    --tx-body-file grabhandsOn1.unsigned \
    --signing-key-file ../Wallet/Addr45.skey \
    $PREVIEW \
    --out-file grabhandsOn1.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file grabhandsOn1.signed


