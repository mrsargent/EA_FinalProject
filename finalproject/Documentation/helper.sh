#### Derive address from script
cardano-cli address build --payment-script-file ./compiled/ak_typeddatum22.uplc --testnet-magic 2 --out-file ak_typeddatum22.addr

#### PubKeyHash creation:
## cardano-cli address key-hash --payment-verification-key-file benef1.vkey --out-file benef1.pkh

#### Create protocol parameters file
## cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

#### Serializing contracts from blueprint for cardano CLI
# aiken blueprint convert -m redeemer11 -v redeemer11 . > redeemer.uplc

#### echo "{\"constructor\" : 0, \"fiels\": [{\"}]}

## // compile validator into .uplc file
#   aiken blueprint convert -m typed_validators -v ourWonderfullValidator . > ./testnet/compiled/ourWonderfullValidator.uplc
# where typed_validators is the actual .ak file and ourWonderfullValidator is the validator inside that file
## // another example 
# aiken blueprint convert -m initialminter -v initialmint . > ./testnet/compiled/initialmint.uplc


#   aiken blueprint address -m typed_validators -v ourWonderfullValidator . > ./testnet/compiled/ourWonderfullValidator.addr
# where typed_validators is the actual .ak file and ourWonderfullValidator is the validator inside that file

#  aiken minting policy comand
#  aiken blueprint policy -m initialminter -v initialmint . > ./testnet/compiled/initialmint.pid

#to view all available validators
# aiken blueprint convert -m .  

# //query to find the TxHash of a particular address.  Basically to find information on utxos
# cardano-cli query utxo --address ADDRESS -- testnet-magic 2

# cardano-cli --version
# cardano-cli query tip --testnet-magic 2
# cardano-cli address key-gen
# cardano-cli stake-address key-gen
# cardano-cli addres build 
# //address creation without staking key.  Look at lesson 0 for code on how to build with staking key
# cardano-cli address build --payment-verification-key-file multiSigEx.vkey --out-file multiSig.addr --testnet-magic 2

# //to get help on anything you can use --help
# cardano-cli --help
# cardano-cli query --help
# cardano-cli address --help
# // etc...


# //creating
# cardano-cli address key-hash --payment-verification-key-file "**".vkey --out-file "**".pkh

# // the > filename.pid is optional.  if you don't put the > filename.pid then the policyid is
# // written to the terminal.  If yout do have the > filename.pid then it creates a file and writes 
# // it to that file.. This is a linux function.  This function produces the "Currency Symbol"
# cardano-cli transaction policyid --script-file (fileName.plutus or filename.script) > filename.pid