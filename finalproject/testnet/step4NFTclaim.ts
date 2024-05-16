import { Blockfrost,
    C,
    Data,
    Lucid,
    SpendingValidator,
    TxHash,
    fromHex,
    toHex,
    applyParamsToScript,
    Constr,
    fromText} from "lucid-cardano" //"https://deno.land/x/lucid@0.10.7/mod.ts";
import * as cbor from "lucid-cardano" //"https://deno.land/x/cbor@v1.4.1/index.js";
import * as J from "https://deno.land/x/jsonschema/jsonschema.ts";

import demo from "./compiled/claimnft.json" assert { type: "json" };


const API_KEY = "previewVUlq7WyCF2wdzZsao48qPAemzR7HCt4l";

const utxoRef = new Constr(0, [
    new Constr(0, ["8c7aa94201eca369c2adcd013c47843ffa0e872bda548e5845b1edce0c11cddc"]),
    BigInt(1)]);


const policyId : string = "0c3626175abe361b24728f3d80e2da26f21c0629cca89542c2935f37";


interface contractJSON {
    "type": string;
    "description": string;
    "cborHex": string;
}

let contract: contractJSON = demo;

const paramsContract = applyParamsToScript(contract.cborHex,[utxoRef,fromText("Gold Star"),fromText("Loyalty Token"),policyId]);

//const paramsContract = applyParamsToScript(contract.cborHex,[fromText("Loyalty Token")]);

const demo2:contractJSON = {
    type: "PlutusScriptV2",
    description: "The Parametrized contract",
    cborHex: paramsContract
}   

const lucid = await Lucid.new(new Blockfrost(
    "https://cardano-preview.blockfrost.io/api/v0",
    API_KEY,
  ), "Preview");

async function writeJson(filePath: string, o: any) {
    await Deno.writeTextFile(filePath, JSON.stringify(o, null, 2));
}

//console.log(demo);
console.log(demo2);

//writeJson("demo.json", demo);
writeJson("./compiled/claimnft_refparam.json", demo2);



// const privateKey = 

// async function readValidator(): Promise<SpendingValidator> {
//     const validator = JSON.parse(await Deno.readTextFile("plutus.json")).validators[0];
//     return {
//       type: "PlutusV2",
//       script: toHex(cbor.encode(fromHex(validator.compiledCode))),
//     };
//   }


// async function mint() {
//     const policy = await C.loadPolicy(demo.policy);
//     const script = await C.loadScript(demo.script);
//     const tx = await lucid.newTransaction();

//     const mintTx = await lucid
//         .newTx()
//         .mintAssets({ [assetName]: 1n }, mintRedeemer)
//         .validTo(Date.now() + 100000)
//         .payToContract(parameterizedContracts!.lockAddress,
//             {
//               // On unlock this gets passed to the redeem
//               // validator as datum. Our redeem validator
//               // doesn't use it so we can just pass in anything.
//               inline: Data.void(),
//             })
//         .attachMintingPolicy(mintingPolicy)
//         .complete();

//     const signedTx = await mintTx.sign([privateKey]);

//     return await signedTx.submit();
// }