// Setup Account 0x04 for child

import FlowToken from 0x02
import FungibleToken from 0x01
import EducationFund from 0x03

transaction {

	prepare(child: AuthAccount) {

        if child.borrow<&EducationFund.Child>(from: /storage/Child) == nil {        
            child.save(<-EducationFund.createNewChild(), to: /storage/Child)

            // Create a public capability to the Vault that only exposes
            // the add capability function through the interface
            child.link<&EducationFund.Child{EducationFund.ChildAddCapPublic}>(
                /public/childAddCapPublic,
                target: /storage/Child
            )
        }
        log("child created")

	}
}
