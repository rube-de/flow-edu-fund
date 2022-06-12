// Copied from flow-core-contracts/transactions/flowToken/setup_account.cdc
// This transaction is a template for a transaction
// to add a Vault resource to their account
// so that they can use the flowToken

import FungibleToken from 0x01
import FlowToken from 0x02

transaction {

    prepare(signer: AuthAccount) {

        if signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault) == nil {
            // Create a new flowToken Vault and put it in storage
            signer.save(<-FlowToken.createEmptyVault(), to: /storage/flowTokenVault)

            // Create a public capability to the Vault that only exposes
            // the deposit function through the Receiver interface
            signer.link<&FlowToken.Vault{FungibleToken.Receiver}>(
                /public/flowTokenReceiver,
                target: /storage/flowTokenVault
            )

            // Create a public capability to the Vault that only exposes
            // the balance field through the Balance interface
            signer.link<&FlowToken.Vault{FungibleToken.Balance}>(
                /public/flowTokenBalance,
                target: /storage/flowTokenVault
            )
        }
    }
    post {
        // Check that the capabilities were created correctly
        getAccount(0x03).getCapability<&FlowToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/FlowReceiver)
                       .check():  
                       "Vault Receiver Reference was not created correctly"
    }
}
 