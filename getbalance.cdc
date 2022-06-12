// Get Balances

import FlowToken from 0x02
import FungibleToken from 0x01
import EducationFund from 0x03

// This script reads the Vault balances of two accounts.
pub fun main() {
    // Get the accounts' public account objects
    let acct3 = getAccount(0x03)
    let acct4 = getAccount(0x04)
    let acct5 = getAccount(0x05)

    // Get references to the account's receivers
    // by getting their public capability
    // and borrowing a reference from the capability
    let acct3ReceiverRef = acct3.getCapability(/public/EducationFundBalance)
                            .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct3 receiver")
    let acct4ReceiverRef = acct4.getCapability(/public/flowTokenBalance)
                            .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct4 receiver")
    let acct5ReceiverRef = acct5.getCapability(/public/flowTokenBalance)
                            .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct5 receiver")

    // Use optional chaining to read and log balance fields
    log("Account 3 Balance")
	log(acct3ReceiverRef.balance)
    log("Account 4 Balance")
	log(acct4ReceiverRef.balance)
    log("Account 5 Balance")
    log(acct5ReceiverRef.balance)
}
