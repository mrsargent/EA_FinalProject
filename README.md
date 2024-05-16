# Emurgo Academy FinalProject - Loalty token distribution

## Introduction

The ability for a Company, in this case Company A, to track customer purchases on the blockchain is paramount. By implementing a system where purchases are recorded on the Cardano blockchain, Company A can ensure the integrity and transparency of its loyalty rewards program. Through this blockchain-based solution, Company A can seamlessly mint and distribute "Loyalty Tokens" (LT) to customers as a reward for their patronage, addressing step one of the project. The blockchain's ledger allows for accurate tracking of customer purchases, ensuring that customers receive the appropriate number of LT based on their spending, as outlined in step two. Furthermore, with the accumulation of LT, customers can claim (mint) a "Gold Star" Loyalty NFT, which grants them special privileges with the company, as described in step three. This Cardano-based system not only facilitates the distribution of rewards but also enables Company A to personalize customer experiences, analyze purchasing patterns, and enhance customer engagement. Overall, the integration of blockchain technology in tracking customer purchases empowers Company A to build trust, loyalty, and lasting relationships with its customers while driving operational efficiency and innovation in its loyalty rewards program.

## Overview

As you can see from the diagram below this is 4 step protocol.

#### Step 1 - Initial Token Mint 
Company_A  is going to mint 10000 initial Loyalty Tokens (LTs).  It will require a signature from Company A along with checking to make sure they will be exactly 10000 tokens minteed with the correct asset name.

![image showing diagram](/img//step1/diagram.jpg)

Below you can see the logic of the minting policy.  It is a parameterized policy so it is taking in the PubKeyHash of Company A as a reference and also the asset name so it can verify the quantity and the name.

![image showing diagram](/img//step1/code.jpg)


Below you can see the cli script that executed the minting policy.  Notice line 23 that fulfilled the requirement for the PubKeyHash.   Also notice line 25 that fulfilled the requirement of the token quantity and assset name.

![image showing diagram](/img//step1/cli.jpg)


#### Step 2 - Validator Value Lock

A user (in this case we'll them User 1) will purchase something in Ada from Company A and submit this value to the validator address.  Comany_A will submit the corresponding number of Loyalty Tokens for the amount of Ada received.  In this case the user submitted a little over 100 Ada and recieved some change the Company A submitted 10 tokens.    

In addition to the value I had to submit the datum.  The datum I am using contained 5 fields: both Company A and User1 PKH, the asset name and policy id of the LT, and the deadline in which this value must be unlocked by.  Below is the code of the datum.  Below is the actual values of the .json file I submitted that has spaces for readability.  The actual file is 1 line.  

![image showing diagram](/img//step2/datum.jpg)

The below cli script was used to submit the previously described data.

![image showing diagram](/img//step2/cli.jpg)


#### Step 3 - Validator Value Unlock
User1 can now unlock the value.  The validator will check if transaction has not passed the deadline, that both User1 and Company A signs the transaction and that Company A will be providing 1 LT for every 10 ADA the user spends.

![image showing diagram](/img//step3/validator.jpg)

This is the script I used to unlock the value from the validator.

![image showing diagram](/img//step3/cli.jpg)

We can see User1 wallet now is in possesion of 10 LTs

![image showing diagram](/img//step3/tokenconfirm.jpg)



#### Step 4 - Claim NFT 
Once a user as accrued 10 or more LTs they can claim a NFT.  This minting policy will check to make sure on only 1 will be minted with the correct asset name, that is is using a valid utxo and that they do indeed have 10 or more LTs. 

![image showing diagram](/img/diagram.jpg)



