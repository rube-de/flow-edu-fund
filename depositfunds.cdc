// Account 0x05 for parent that deposits

import FlowToken from 0x02
import FungibleToken from 0x01
import EducationFund from 0x03

transaction {
    let temporaryVault: @FungibleToken.Vault
    prepare(parent: AuthAccount) {
        let vaultRef = parent.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
        ?? panic("Could not borrow a reference to the owner's vault")
      
        self.temporaryVault <- vaultRef.withdraw(amount: 10.0)
    }

    execute {
        // get the recipient's public account object
        let recipient = getAccount(0x03)

        // get the recipient's Receiver reference to their Vault
        // by borrowing the reference from the public capability
        let receiverRef = recipient.getCapability(/public/EducationFundReceiver)
                        .borrow<&FlowToken.Vault{FungibleToken.Receiver}>()
                        ?? panic("Could not borrow a reference to the receiver")

        // deposit your tokens to their Vault
        receiverRef.deposit(from: <-self.temporaryVault)

        log("deposit succeeded!")
    }
}