import Quick
import Nimble
import Moya
import OHHTTPStubs
@testable import Swift_Issues

class IssuesViewModelSpecs: QuickSpec {

    override func spec() {
        describe("IssuesViewModel") {
            var subject: IssuesViewModel!
            var tableResult: IssuesTableViewResult!

            beforeEach {
                subject = IssuesViewModel(provider: MoyaProvider<GitHub>())
                tableResult = IssuesTableViewResult()
            }
            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("Given fetchIssues") {
                context("When JSON result is OK") {
                    beforeEach {
                        self.stubHTTP(withFile: "1IssueList.json")
                    }

                    it("Then presents row in table view") {

                        let cellResult = IssueTableViewCellResult()
                        waitUntil { done in
                            subject.fetchIssues { errorMessage in
                                subject.executeFetchResult(delegate: tableResult,
                                                           errorMessage: errorMessage)
                                subject.fillIssueData(withDelegate: cellResult,
                                                      forCellAt: 0)
                                done()
                            }
                        }
                        expect(tableResult.errorMessage).to(beNil())
                        expect(subject.getNumberOfIssues()).to(equal(1))
                        expect(cellResult.title).to(equal("Test title."))
                        expect(cellResult.status).to(equal("open"))
                    }
                }

                context("When JSON result is OK") {
                    beforeEach {
                        self.stubHTTP(withFile: "1IssueList.json")
                    }

                    it("Then creates IssuePageViewModel") {
                        waitUntil { done in
                            subject.fetchIssues { errorMessage in
                                subject.executeFetchResult(delegate: tableResult,
                                                           errorMessage: errorMessage)
                                done()
                            }
                        }
                        expect(tableResult.errorMessage).to(beNil())
                        expect(subject.getNumberOfIssues()).to(equal(1))
                        let viewModelResult = subject.getIssuePageViewModel(forIndex: 0)
                        expect(viewModelResult).toNot(beNil())
                    }
                }

                context("When JSON result is empty") {
                    beforeEach {
                        self.stubHTTP(withFile: "EmptyList.json")
                    }
                    it("Then show error message") {
                        waitUntil { done in
                            subject.fetchIssues { errorMessage in
                                subject.executeFetchResult(delegate: tableResult,
                                                           errorMessage: errorMessage)
                                done()
                            }
                        }
                        expect(tableResult.errorMessage).to(equal("Failed to map data to a Decodable object."))
                    }
                }

                context("When JSON result is corrupted") {
                    beforeEach {
                        self.stubHTTP(withFile: "CorruptedList.json")
                    }
                    it("Then show error message") {
                        waitUntil { done in
                            subject.fetchIssues { errorMessage in
                                subject.executeFetchResult(delegate: tableResult,
                                                           errorMessage: errorMessage)
                                done()
                            }
                        }
                        expect(tableResult.errorMessage).to(equal("Failed to map data to a Decodable object."))
                    }
                }

                context("When there is a network error") {
                    beforeEach {
                        self.stubHTTPError(withCode: 500)
                    }
                    it("Then show error message") {
                        waitUntil { done in
                            subject.fetchIssues { errorMessage in
                                subject.executeFetchResult(delegate: tableResult,
                                                           errorMessage: errorMessage)
                                done()
                            }
                        }
                        expect(tableResult.errorMessage).to(equal("Response status code was unacceptable: 500."))
                    }
                }
            }
        }
    }
}

// MARK: - HTTP Stubs
extension IssuesViewModelSpecs {

    private func stubHTTP(withFile filename: String) {
        stub(condition: isPath("/repos/apple/swift/issues")) { request in
            let stubPath = OHPathForFile(filename,
                                         type(of: self))!
            return fixture(filePath: stubPath,
                           headers: ["Content-Type": "application/json"])
        }
    }

    private func stubHTTPError(withCode code: Int32) {
        stub(condition: isPath("/repos/apple/swift/issues")) { request in
            let stubPath = OHPathForFile("EmptyList.json",
                                         type(of: self))!
            return fixture(filePath: stubPath, status: code,
                           headers: ["Content-Type": "application/json"])

        }
    }
}

// MARK: - Result classes
private class IssuesTableViewResult: IssuesTableViewDelegate {
    var errorMessage: String?

    func reloadIssuesList() {
        // Does nothing
    }

    func showErrorMessage(_ message: ErrorMessage) {
        self.errorMessage = message
    }
}

private class IssueTableViewCellResult: IssueTableViewCellDelegate {
    var title: String?
    var status: String?

    func setIssueCell(withTitle title: String,
                      andStatus status: String) {
        self.title = title
        self.status = status
    }
}
