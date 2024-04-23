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


#   aiken blueprint address -m typed_validators -v ourWonderfullValidator . > ./testnet/compiled/ourWonderfullValidator.addr
# where typed_validators is the actual .ak file and ourWonderfullValidator is the validator inside that file

#to view all available validators
# aiken blueprint convert -m .  