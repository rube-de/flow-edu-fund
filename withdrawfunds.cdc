// Account 0x04 for chil

import FlowToken from 0x02
import FungibleToken from 0x01
import EducationFund from 0x03

transaction {

	prepare(child: AuthAccount) {
        let childRef = child.borrow<&EducationFund.Child>(from: /storage/Child)
            ?? panic("Could not borrow child")
        let vaultRef = child.borrow<&FungibleToken.Vault>(from: /storage/flowTokenVault)
             ?? panic("Could not borrow vault")

        vaultRef.deposit(from: <- childRef.withdraw(amount: 10.0))

        log("withdraw successful")
    }
}