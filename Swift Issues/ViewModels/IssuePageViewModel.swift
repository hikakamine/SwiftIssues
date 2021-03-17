import Foundation
import Moya

class IssuePageViewModel {
    private let issue: Issue
    private let provider: MoyaProvider<GitHub>

    private var imageData: Data!

    init(issue: Issue, provider: MoyaProvider<GitHub>) {
        self.issue = issue
        self.provider = provider
    }

    // MARK: - Public methods

    func fillIssueDetailsData(withDelegate delegate: IssuePageViewDelegate) {
        delegate.setIssueInformation(title: issue.title,
                                     creationInfo: issue.getIssueCreationDetails(),
                                     description: issue.body)
    }

    func fetchUserAvatar(completionHandler: @escaping (ErrorMessage?) -> Void) {
        guard let imageUrl = issue.user?.avatarUrl else {
            completionHandler("Avatar URL unavailable")
            return
        }

        provider.request(.avatar(url: imageUrl)) { [unowned self] result in
            var errorMessage: ErrorMessage?
            switch result {
                case .failure(let error):
                    errorMessage = error.errorDescription
                case .success(let response):
                    self.imageData = response.data
            }
            completionHandler(errorMessage)
        }
    }

    func setUserAvatar(withDelegate delegate: IssuePageViewDelegate,
                       orShowError errorMessage: ErrorMessage?) {
        if let message = errorMessage {
            delegate.showErrorMessage(message)
            return
        }

        delegate.setUserAvatar(fromData: imageData)
    }

    func openIssuePage(withDelegate delegate: IssuePageViewDelegate) {
        guard let url = issue.htmlUrl else {
            delegate.showErrorMessage("No url available for this issue")
            return
        }
        delegate.openIssueUrl(url: url)
    }
}
