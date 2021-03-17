import Quick
import Nimble
import Moya
import OHHTTPStubs
@testable import Swift_Issues

class IssuePageViewModelSpecs: QuickSpec {

    override func spec() {
        describe("IssuePageViewModel") {
            var subject: IssuePageViewModel!
            var result: IssuePageViewResult!

            beforeEach {
                result = IssuePageViewResult()
            }
            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("Given fillIssueDetailsData") {
                context("When Issue has all data") {
                    beforeEach {
                        subject = IssuePageViewModel(issue: Issue.completeIssue,
                                                     provider: MoyaProvider<GitHub>())
                    }

                    it("Then present data in the view") {
                        subject.fillIssueDetailsData(withDelegate: result)
                        expect(result.title).to(equal("Title"))
                        expect(result.creationInfo).to(equal("User userLogin created the issue in 2021/03/10"))
                        expect(result.description).to(equal("Description"))
                    }
                }
            }

            describe("Given fetchUserAvatar") {
                context("When Issue has avatar URL and HTTP response is OK") {
                    beforeEach {
                        subject = IssuePageViewModel(issue: Issue.completeIssue,
                                                     provider: MoyaProvider<GitHub>())
                        self.stubHTTP(withImage: "DefaultAvatar.png")
                    }

                    it("Then download and present image") {
                        waitUntil { done in
                            subject.fetchUserAvatar { errorMessage in
                                subject.setUserAvatar(withDelegate: result,
                                                      orShowError: errorMessage)
                                done()
                            }
                        }
                        expect(result.errorMessage).to(beNil())
                        expect(result.avatarImage).toNot(beNil())
                    }
                }

                context("When Issue has avatar URL but HTTP response is 500") {
                    beforeEach {
                        subject = IssuePageViewModel(issue: Issue.completeIssue,
                                                     provider: MoyaProvider<GitHub>())
                        self.stubHTTPError(withCode: 500)
                    }

                    it("Then show error for image") {
                        waitUntil { done in
                            subject.fetchUserAvatar { errorMessage in
                                subject.setUserAvatar(withDelegate: result,
                                                      orShowError: errorMessage)
                                done()
                            }
                        }
                        expect(result.errorMessage).to(equal("Response status code was unacceptable: 500."))
                    }
                }

                context("When Issue does not has User data") {
                    beforeEach {
                        subject = IssuePageViewModel(issue: Issue.incompleteIssue,
                                                     provider: MoyaProvider<GitHub>())
                    }

                    it("Then show error for image") {
                        waitUntil { done in
                            subject.fetchUserAvatar { errorMessage in
                                subject.setUserAvatar(withDelegate: result,
                                                      orShowError: errorMessage)
                                done()
                            }
                        }
                        expect(result.errorMessage).to(equal("Avatar URL unavailable"))
                    }
                }
            }

            describe("Given openIssuePage") {
                context("When Issue has the URL") {
                    beforeEach {
                        subject = IssuePageViewModel(issue: Issue.completeIssue,
                                                     provider: MoyaProvider<GitHub>())
                    }

                    it("Then presents Issue's URL") {
                        subject.openIssuePage(withDelegate: result)
                        expect(result.url).to(equal(URL(string: "https://github.com/apple/swift/pull/1")))
                    }
                }

                context("When there is no URL available") {
                    beforeEach {
                        subject = IssuePageViewModel(issue: Issue.incompleteIssue,
                                                     provider: MoyaProvider<GitHub>())
                    }

                    it("Then show error") {
                        subject.openIssuePage(withDelegate: result)
                        expect(result.errorMessage).to(equal("No url available for this issue"))
                    }
                }
            }
        }
    }
}

// MARK: - HTTP Stubs
extension IssuePageViewModelSpecs {

    private func stubHTTP(withImage filename: String) {
        stub(condition: isHost("avatars.githubusercontent.com")) { request in
            let stubPath = OHPathForFile(filename,
                                         type(of: self))!
            return fixture(filePath: stubPath,
                           headers: ["Content-Type": "image/png"])
        }
    }

    private func stubHTTPError(withCode code: Int32) {
        stub(condition: isHost("avatars.githubusercontent.com")) { request in
            let stubPath = OHPathForFile("EmptyList.json",
                                         type(of: self))!
            return fixture(filePath: stubPath, status: code,
                           headers: ["Content-Type": "application/json"])

        }
    }
}

// MARK: - Result classes
private class IssuePageViewResult: IssuePageViewDelegate {
    var title: String?
    var creationInfo: String?
    var description: String?
    var avatarImage: UIImage?
    var url: URL?
    var errorMessage: ErrorMessage?

    func setIssueInformation(title: String,
                             creationInfo: String,
                             description: String) {
        self.title = title
        self.creationInfo = creationInfo
        self.description = description
    }

    func setUserAvatar(fromData data: Data) {
        self.avatarImage = data.asImage
    }

    func openIssueUrl(url: URL) {
        self.url = url
    }

    func showErrorMessage(_ message: ErrorMessage) {
        self.errorMessage = message
    }
}
