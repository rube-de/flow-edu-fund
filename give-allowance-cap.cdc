// Setup allowance cap for parent 0x05

import FlowToken from 0x02
import FungibleToken from 0x01
import EducationFund from 0x03

transaction {    

	prepare(admin: AuthAccount) {

        let allowanceCap = admin.getCapability<&EducationFund.AllowanceAdmin>(/private/EducationFundAllowanceAdmin)

        let parent = getAccount(0x05)

        let capabilityReceiver = parent.getCapability<&EducationFund.Parent{EducationFund.ParentAddCapPublic}>(
                /public/parentAddCapPublic).borrow()
                ?? panic("could not borrow capability")

        capabilityReceiver.addCapability(cap: allowanceCap)

        log("cap for parent created")

	}
}
