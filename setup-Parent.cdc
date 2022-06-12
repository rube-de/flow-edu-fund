// Setup Account 0x05 for parent

import FlowToken from 0x02
import FungibleToken from 0x01
import EducationFund from 0x03

transaction {  

	prepare(parent: AuthAccount) {

        if parent.borrow<&EducationFund.Parent>(from: /storage/Parent) == nil {        
            parent.save(<-EducationFund.createNewParent(), to: /storage/Parent)

            // Create a public capability to the Vault that only exposes
            // the add capbability function through the interface
            parent.link<&EducationFund.Parent{EducationFund.ParentAddCapPublic}>(
                /public/parentAddCapPublic,
                target: /storage/Parent
            )
        }

        log("parent created")

	}
}