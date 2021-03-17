import Quick
import Nimble
@testable import Swift_Issues

class DateExtensionsSpecs: QuickSpec {
    override func spec() {
        describe("Date") {
            var subject: Date!

            describe("Given formatted") {
                beforeEach {
                    // 2021/03/10 12:00:00 PM GMT-03:00
                    subject = Date(timeIntervalSince1970: 1615388400)
                }

                context("When formatted with the default pattern") {
                    it("Then shows date in yyyy/MM/hh format") {
                        let result = subject.formatted()
                        expect(result).to(equal("2021/03/10"))
                    }
                }

                context("When using a given format") {
                    it("Then shows date in the format") {
                        let result = subject.formatted(withFormat: "yyyy, MMM dd")
                        expect(result).to(equal("2021, Mar 10"))
                    }
                }
            }
        }
    }
}
