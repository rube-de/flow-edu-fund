// Setup withdraw cap for child 0x04

import FlowToken from 0x02
import FungibleToken from 0x01
import EducationFund from 0x03

transaction {    

	prepare(admin: AuthAccount) {

        let vaultCap = admin.getCapability<&FungibleToken.Vault>(/private/EducationFundVault)

        let child = getAccount(0x04)

        let capabilityReceiver = child.getCapability<&EducationFund.Child{EducationFund.ChildAddCapPublic}>(
                /public/childAddCapPublic).borrow()
                ?? panic("could not borrow capability")

        capabilityReceiver.addCapability(cap: vaultCap)

        log("cap for child created")

	}
}
