# Emurgo Academy Final Project - Loalty Token Distribution

## Introduction

The ability for a Company, in this case Company A, to track customer purchases on the blockchain is paramount. By implementing a system where purchases are recorded on the Cardano blockchain, Company A can ensure the integrity and transparency of its loyalty rewards program. Through this blockchain-based solution, Company A can seamlessly mint and distribute "Loyalty Tokens" (LT) to customers as a reward for their patronage. The blockchain's ledger allows for accurate tracking of customer purchases, ensuring that customers receive the appropriate number of LT based on their spending. Furthermore, with the accumulation of LT, customers can claim (mint) a "Gold Star" Loyalty NFT, which grants them special privileges with the company. This Cardano-based system not only facilitates the distribution of rewards but also enables Company A to personalize customer experiences, analyze purchasing patterns, and enhance customer engagement. Overall, the integration of blockchain technology in tracking customer purchases empowers Company A to build trust, loyalty, and lasting relationships with its customers while driving operational efficiency and innovation in its loyalty rewards program.

## Overview

As you can see from the diagram below this is 4 step protocol.  First, we will be minting a native token.  Second we will be locking value.  Third we will be unlocking value from a validator. And finally we will be minting a NFT.  The following will explain each step in detail.

![image showing diagram](/img/diagram.jpg)

#### Step 1 - Initial Token Mint 
Company_A  is going to mint 10000 initial Loyalty Tokens (LTs) with the initialMinter minting policy.  This policy will require a signature from Company A to ensure that **only Company A is allowed to mint**. In addition it will check to make sure they will be exactly 10000 tokens minted with the correct asset name (see initialminter.ak in the project).

![image showing diagram](/img//step1/diagram.jpg)

Below you can see the logic of the minting policy.  It is a parameterized policy so it is taking in the verification key hash of Company A as a reference and also the asset name so it can verify the quantity and the name of the native token (LT).

![image showing diagram](/img//step1/code.jpg)


Below you can see the cli script that executed the minting policy.  Notice line 23 that fulfilled the requirement for the verification key hash.   Also notice line 25 that fulfilled the requirement of the token quantity and assset name.

![image showing diagram](/img//step1/cli.jpg)

<span style="color:red;"> As a note this minting policy had additional parameters.  The Company verification key hash and the token asset name were parameterized in the minting policy. You can see step1InitialMint.ts in the project to see how I parameterized these to be used in the actual minting policy. </span>

#### Step 2 - Validator Value Lock

A user (in this case we'll them User 1) will purchase something in Ada from Company A and submit this value to the validator address.  Comany_A will submit the corresponding number of Loyalty Tokens for the amount of Ada received.  For this loyality program it is a 10:1 ratio.  In this case the user submitted a little over 100 Ada and received some change and Company A submitted 10 tokens in the transaction.

![image showing diagram](/img//step2/diagram.jpg)

In addition to the value the datum had to be submitted.  The datum that is used contained 5 fields: both Company A and User1 verification key hash, the asset name and policy id of the LT, and the deadline in which this value must be unlocked by.  Below is the code of the datum.  Below the code in the commented section is the actual values of the .json file that was submitted that has spaces for readability.  The actual file is 1 line (see requirement_datum.json).   

![image showing diagram](/img//step2/datum.jpg)

The below cli script was used to submit the previously described data.

![image showing diagram](/img//step2/cli.jpg)


#### Step 3 - Validator Value Unlock
User1 can now unlock the value.  The validator will check if transaction has not passed the deadline, that both User1 and Company A have signed the transaction and that Company A will be providing 1 LT for every 10 ADA the user spends.  In addition, Company A will recieve the Ada that was spent (see loyalityvalidator.ak in project).

![image showing diagram](/img//step3/validator.jpg)

This sript was used to unlock the value from the validator.

![image showing diagram](/img//step3/cli.jpg)

We can see User1 wallet now is in possesion of 10 LTs.

![image showing diagram](/img//step3/tokenconfirm.jpg)



#### Step 4 - Claim NFT 
Once a user as accrued 10 or more LTs they can claim a "Gold Star" NFT.  This is done through a minting policy that will check to make sure on only 1 NFT will be minted with the correct asset name. The policy also checks that it is using a valid utxo that can only be used once and that they do indeed have 10 or more LTs (see claimnft.ak in project).  No signature is required as anyone with atleast 10 LT can mint a NFT.

![image showing diagram](/img//step4/diagram.jpg)

Below is the minting policy that was used

![image showing diagram](/img//step4/mintingpolicy.jpg)

Submitted was the previous utxo from User1 that contained the 10 LT tokens.  I also included another utxo from User1 to provide enough Ada to mint the NFT.  Here is the cli script used

 ![image showing diagram](/img//step4/cli.jpg)

The final result is the NFT is in the User1 wallet

 ![image showing diagram](/img//step4/result.jpg)


<span style="color:red;"> As a note this minting policy had additional parameters as well.  The utxoRef, NFT name, Loyalty token policy id and asset name were all parameterized in this policy.  See step4NFTClaim.ts in the project for more details. </span>

## Using the Project

#### Compile

You can compile the code by navigating to the main directory of the project and use the **aiken check** command.  You will also be able to see all the tests that were passed to prove the functionality of all the functions in the project.


![image showing diagram](/img//project/compile.jpg)

You can do an optional **aiken build** to recompile the blueprint although that would be unnecesaary since all the compile files are in finalproject/testnet/compiled.


#### Execute Scripts
You can execute the shell scripts to reproduce the results.  These are all described with descriptive wording for each step in finalproject/testnet/shellscripts.  You will have to change all the utxos in teh scripts as ones currently provided have been consumed.  The provided wallets in the finalproject/Wallet for Company A and User1 must be used as in the initial minter and the validator it requires the verification key hash of both users to avoid malicious people minting and stealing tokens. 







