import FungibleToken from 0x01
import FlowToken from 0x02


pub contract EducationFund {

  pub var allowance: UFix64

  // The init() function is required if the contract contains any fields.
  init() {
      self.allowance = 0.0
      let vault <- FlowToken.createEmptyVault()
      self.account.save(<-vault, to: /storage/flowTokenVault)

      // Create a public capability to the stored Vault that only exposes
      // the `deposit` method through the `Receiver` interface
      //
      self.account.link<&FlowToken.Vault{FungibleToken.Receiver}>(
          /public/EducationFundReceiver,
          target: /storage/flowTokenVault
      )

      // Create a public capability to the stored Vault that only exposes
      // the `balance` field through the `Balance` interface
      //
      self.account.link<&FlowToken.Vault{FungibleToken.Balance}>(
          /public/EducationFundBalance,
          target: /storage/flowTokenVault
      )

      self.account.link<&FlowToken.Vault>(
          /private/EducationFundVault,
          target: /storage/flowTokenVault
      )

      let allowanceAdmin <- create AllowanceAdmin()
      self.account.save(<- allowanceAdmin, to: /storage/AllowanceAdmin)  
      self.account.link<&EducationFund.AllowanceAdmin>(/private/EducationFundAllowanceAdmin, target: /storage/AllowanceAdmin)

  }

  // createNewChild
  //
  // Function that creates and returns a new child resource
  //
  pub fun createNewChild(): @Child {
      return <-create Child()
  }

  // createNewParent
  //
  // Function that creates and returns a new parent resource
  //
  pub fun createNewParent(): @Parent {
      return <-create Parent()
  }

  pub resource interface ChildAddCapPublic {
      pub fun addCapability(cap: Capability<&FungibleToken.Vault>) 
  }

  pub resource Child: ChildAddCapPublic{
      access(self) var withdrawCapability: Capability<&FungibleToken.Vault>?

      init() {
          self.withdrawCapability = nil
      }

      pub fun addCapability(cap: Capability<&FungibleToken.Vault>) {
          pre {
              cap.borrow() != nil: "Invalid capability"
          }
          self.withdrawCapability = cap
      }

      pub fun withdraw(amount: UFix64): @FungibleToken.Vault {
        pre{
          amount >= EducationFund.allowance
          self.withdrawCapability != nil
        }
        EducationFund.allowance = EducationFund.allowance - amount
        return <- self.withdrawCapability!.borrow()!.withdraw(amount: amount)

      }
  }

    pub resource AllowanceAdmin {
        pub fun AddAllowance(amount: UFix64) {
            EducationFund.allowance = EducationFund.allowance + amount
        }
    }

    pub resource interface ParentAddCapPublic {
      pub fun addCapability(cap: Capability<&EducationFund.AllowanceAdmin>) 
  }

    pub resource Parent: ParentAddCapPublic {
        access(self) var allowanceCapability: Capability<&EducationFund.AllowanceAdmin>?

        init(){
            self.allowanceCapability = nil
        }

        pub fun addCapability(cap: Capability<&EducationFund.AllowanceAdmin>) {
            pre {
              cap.borrow() != nil: "Invalid capability"
            }
            self.allowanceCapability = cap
        }

        pub fun addAllowance(amount: UFix64) {
            pre{
                self.allowanceCapability != nil
            }
        self.allowanceCapability!.borrow()!.AddAllowance(amount: amount)
        }
    }

}
