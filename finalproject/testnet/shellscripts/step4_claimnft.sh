# this is the shell commands for claiming the NFT.  Must be 1 token only.  Minting policy will check the utxo to make sure
#it is the correct one being spent.  Requires no signer

utxoin_with_lt="09fe9df169262a6ce918ac9f41a613cafbc1802a30f125b433971bc029dcbd65#0"
utxoin_with_ada="8c7aa94201eca369c2adcd013c47843ffa0e872bda548e5845b1edce0c11cddc#1"
policyid="97bae8e8fff46fe89e7295b3cdb4f0bdd4b6e8b0b85c58faaba1f261"
user1_addr="addr_test1vq3fgaulvhe4knqkmgpz2yu22da2msa2d5p3ds9ncvj4fgcldkaz4"
output="5000000"
tokenamount="1"
tokenname="476f6c642053746172"   #$(echo -n "Gold Star" | xxd -ps | tr -d '\n')
collateral="4528acfc94ecfbce93391649397d52f1231e1cfe9f2317116294a8f774d0b32c#0"
PREVIEW="--testnet-magic 2"
mintingScript="./../compiled/claimnft_refparam.json"
lt_tokenname="4c6f79616c747920546f6b656e" 
lt_policyid="0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37"
lt_tokenamount="10"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin_with_lt \
  --tx-in $utxoin_with_ada \
  --tx-in-collateral $collateral \
  --tx-out $user1_addr+$output+"$tokenamount $policyid.$tokenname" \
  --tx-out $user1_addr+$output+"$lt_tokenamount $lt_policyid.$lt_tokenname" \
  --change-address $user1_addr \
  --mint "$tokenamount $policyid.$tokenname" \
  --mint-script-file $mintingScript \
  --mint-redeemer-file ./../values/empty.json \
  --protocol-params-file protocol.params \
  --out-file initialmint.unsigned

cardano-cli transaction sign \
    --tx-body-file initialmint.unsigned \
    --signing-key-file ./../../Wallet/User1.skey \
    $PREVIEW \
    --out-file initialmint.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file initialmint.signed