from brownie import Dao, config, network, accounts
from scripts.help import get_account
from web3 import Web3


def deploy():
	account = get_account()
	dao = Dao.deploy({"from": account})
	print("Dao deployed!")


def startElection():
	account = get_account()
	dao = Dao[-1]
	tx = dao.startVoting({"from": account})
	tx.wait(1)
	print("Voting Started")


def registerProposal():
	account = get_account()
	dao = Dao[-1]
	tx = dao.registerProposal(
		config["networks"][network.show_active()]["address_to_contract"], 
		100, 
		"Proposal1",
		"aave flashloan"
	)
	print("Proposal 1 registered")
	tx = dao.registerProposal(
		config["networks"][network.show_active()]["address_to_contract_two"], 
		100, 
		"Proposal2",
		"aave flashloan2"
	)
	tx.wait(1)
	print("Proposal 2 registered")


def getPower():
	account = get_account()
	dao = Dao[-1]
	amount = Web3.toWei(0.1, "ether")
	tx = dao.getPower({"from": account, "value": amount})
	tx.wait(1)
	print("Power switched")
	tx2 = dao.showPower({"from": account})
	print(f"Your power is {tx2}")


def vote():
	account = get_account()
	dao = Dao[-1]
	tx = dao.vote(0, {"from": account})
	tx.wait(1)
	print("Vote succesful")
	# You could also vote with multiple accounts but in my case I don't have enough kovan accounts so it would work on testnet
	# Thats why I didn't include it in the code



def endVoting():
	account = get_account()
	dao = Dao[-1]
	tx = dao.endVoting({"from": account})
	tx.wait(1)
	print("Voting ended")


def countVotes():
	account = get_account()
	dao = Dao[-1]
	dao.countVotes({"from": account})
	print("Votes counted")


def showWinner():
	account = get_account()
	dao = Dao[-1]
	tx = dao.winnerName({"from": account})
	print(f"The winning proposal is {tx}")


def main():
	deploy()
	startElection()
	registerProposal()
	getPower()
	vote()
	endVoting()
	countVotes()
	showWinner()