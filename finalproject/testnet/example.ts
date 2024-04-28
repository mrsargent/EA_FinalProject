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
    fromText} from "https://deno.land/x/lucid@0.10.7/mod.ts";
import * as cbor from "https://deno.land/x/cbor@v1.4.1/index.js";
// import * as J from "https://deno.land/x/jsonschema/jsonschema.ts";


import demo from "./eaNFT.json" assert { type: "json" };


const utxoRef = new Constr(0, [
    new Constr(0, ["405fcdd2ccb5b9437c073e2ad340b56e09030986"]),
    BigInt(4)]);


interface contractJSON {
    "type": string;
    "description": string;
    "cborHex": string;
}

let contract: contractJSON = demo;

const paramsContract = applyParamsToScript(contract.cborHex,[utxoRef,fromText("DaCoin")])

const demo2:contractJSON = {
    type: "PlutusV2",
    description: "The Parametrized contract",
    cborHex: paramsContract
}   

const lucid = await Lucid.new(new Blockfrost(
    "https://cardano-preview.blockfrost.io/api/v0",
    Deno.env.get("BLOCKFROST_API_KEY"),
  ), "Preview");

async function writeJson(filePath: string, o: any) {
    await Deno.writeTextFile(filePath, JSON.stringify(o, null, 2));
}

console.log(demo);
console.log(demo2);

writeJson("demo.json", demo);
writeJson("demo2.json", demo2);


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