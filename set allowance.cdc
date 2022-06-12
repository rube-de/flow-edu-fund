// Account 0x05 for parent

import FlowToken from 0x02
import FungibleToken from 0x01
import EducationFund from 0x03

transaction {
	prepare(parent: AuthAccount) {
        let parentRef = parent.borrow<&EducationFund.Parent>(from: /storage/Parent)
                         ?? panic("Could not borrow a reference to parent")

        parentRef.addAllowance(amount: 10.0)

        log("allowance in fund:")
        log(EducationFund.allowance)
    }
}