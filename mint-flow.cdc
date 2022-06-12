// Copy from flow-core-contracts/transactions/flowToken/mint_tokens.cdc
// Mint Tokens

import FlowToken from 0x02
import FungibleToken from 0x01

// This transaction mints tokens and deposits them into account 3's vault
transaction {
    let tokenAdmin: &FlowToken.Administrator
    let tokenReceiver: &{FungibleToken.Receiver}

    // Local variable for storing the reference to the minter resource
    var ref: &FlowToken.Minter

	prepare(acct: AuthAccount) {
        self.tokenAdmin = acct.borrow<&FlowToken.Administrator>(from: /storage/flowTokenAdmin) 
                            ?? panic("Signer is not the token admin")

        let recipient = getAccount(0x05)
        self.tokenReceiver = recipient.getCapability(/public/flowTokenReceiver)
                            .borrow<&{FungibleToken.Receiver}>()
                            ?? panic("Unable to borrow receiver reference")

//old
        let mintingRef <- self.tokenAdmin.createNewMinter(allowedAmount: 100.0)
        acct.save<@FlowToken.Minter>(<-mintingRef, to: /storage/FlowMinter)

        let mintingCap = acct.link<&FlowToken.Minter>(/private/FlowMinter, target: /storage/FlowMinter)

        self.ref = acct.borrow<&FlowToken.Minter>(from: /storage/FlowMinter)
                            ?? panic ("could not borrow minter")

	}

    execute {
        let minter <- self.tokenAdmin.createNewMinter(allowedAmount: 100.0)
        let mintedVault <- minter.mintTokens(amount: 100.0)

        self.tokenReceiver.deposit(from: <-mintedVault)

        destroy minter
    }
}
 
