This project was created with Brownie-ETH.

This contract allows any dao to vote on any proposals

First you have to start the voting process by calling the startVoting function. This function will set the time that the community will 
be able to register proposals and vote;

You can change the timeframe by changing the timePeriod intiger. Default is 10 minutes;


After you start the trasaction the communitiy can register their proposals. 

They have to enter their address to which the tokens will be send if that proposal wins(This version doesn't have that) then amount
that they need to start their project, name of the proposal and description of what they want to do with the funds.

Then voters need to get power to vote by calling the getPower function. For every eth you receive 10 power. 
This isn't the most secure way but it's good enough for now. In next versions I will try to create a better model for this problem.
The more power you have the bigger impact you will have on the election.
So basically if the proposals gets the most votes it doesn't necessarily mean they will win. 


After getting the power you can finnaly vote. Just enter number of the proposal you want to vote for startgin from zero 
with logic 0 = 1st proposal, 1 = 2nd proposal and so on;



After the vote is over you can call the winnerName function that will show you which proposal won. You can call this function only
after the voting period ended that the community set at the start of the voting.

In next versions the contract will also send the tokens for the proposal that won.
