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

import demo from "./compiled/initialmint.json" assert { type: "json" };


const API_KEY = "previewVUlq7WyCF2wdzZsao48qPAemzR7HCt4l";

const pkh = new Constr(0, [
    new Constr(0, ["c32b8657a48213b56cdcbbd22d373e77a76394c9a0bfd098bb72d8f1"])]);

///********** this is what it seem like it should be !!!!!!!!!!!!!!!!!!!!!!!1 */
const pkh1 = new Constr(0, ["c32b8657a48213b56cdcbbd22d373e77a76394c9a0bfd098bb72d8f1"]);   

 
interface contractJSON {
    "type": string;
    "description": string;
    "cborHex": string;
}

let contract: contractJSON = demo;

const paramsContract = applyParamsToScript(contract.cborHex,[pkh,fromText("Loyalty Token")])

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
writeJson("./compiled/initialmint_refparam.json", demo2);


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