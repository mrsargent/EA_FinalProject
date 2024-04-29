# Emurgo Academy FinalProject - Loalty token distribution

## Introduction

The ability for a Company, in this case Company A, to track customer purchases on the blockchain is paramount. By implementing a system where purchases are recorded on the Cardano blockchain, Company A can ensure the integrity and transparency of its loyalty rewards program. Through this blockchain-based solution, Company A can seamlessly mint and distribute "Loyalty Tokens" (LT) to customers as a reward for their patronage, addressing step one of the project. The blockchain's ledger allows for accurate tracking of customer purchases, ensuring that customers receive the appropriate number of LT based on their spending, as outlined in step two. Furthermore, with the accumulation of LT, customers can claim (mint) a "Gold Star" Loyalty NFT, which grants them special privileges with the company, as described in step three. This Cardano-based system not only facilitates the distribution of rewards but also enables Company A to personalize customer experiences, analyze purchasing patterns, and enhance customer engagement. Overall, the integration of blockchain technology in tracking customer purchases empowers Company A to build trust, loyalty, and lasting relationships with its customers while driving operational efficiency and innovation in its loyalty rewards program.

## Overview

As you can see from the diagram below this is 3 step protocol.

#### Step 1. 
Company_A  is going to mint 10000 initial Loyalty Tokens (LTs).  It will require a signature from Company A along with checking to make sure they will be exactly 10000 tokens minteed with the correct asset name.

#### Step 2. 
A user (in this case we'll them User 1) will purchase something in ada from Company A.  The validator will check if has not passed the deadline, that Company A will be providing 1 LT for every 10 ADA the user spends, and that both the user and Company A has signed the transaction.

#### Step 3. 
Once a user as accrued 10 or more LTs they can claim a NFT.  This minting policy will check to make sure on only 1 will be minted with the correct asset name, that is is using a valid utxo and that they do indeed have 10 or more LTs. 

![image showing diagram](/img/diagram.jpg)



