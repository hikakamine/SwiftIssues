import Quick
import Nimble
@testable import Swift_Issues

class IssueExtensionsSpecs: QuickSpec {

    override func spec() {
        describe("Issue") {
            var subject: Issue!

            describe("Given getIssueCreationDetails") {

                context("When issue data is complete") {
                    beforeEach {
                        subject = Issue.completeIssue
                    }

                    it("Then shows creation details") {
                        let result = subject.getIssueCreationDetails()
                        expect(result).to(equal("User userLogin created the issue in 2021/03/10"))
                    }
                }

                context("When issue data is incomplete") {
                    beforeEach {
                        subject = Issue.incompleteIssue
                    }

                    it("Then shows creation details with unknown data") {
                        let result = subject.getIssueCreationDetails()
                        expect(result).to(equal("User [unknown user] created the issue in [unknown date]"))
                    }
                }
            }
        }
    }
}
