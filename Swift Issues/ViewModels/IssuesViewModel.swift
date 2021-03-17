import Foundation
import Moya

class IssuesViewModel {
    private var issuesList = [Issue]()
    private let provider: MoyaProvider<GitHub>

    init(provider: MoyaProvider<GitHub>) {
        self.provider = provider
    }

    // MARK: - Public methods

    func fetchIssues(completionHandler: @escaping (ErrorMessage?) -> Void) {
        provider.request(.issues) { [unowned self] result in
            completionHandler(self.decodeToList(fromResult: result))
        }
    }

    func executeFetchResult(delegate: IssuesTableViewDelegate,
                            errorMessage: ErrorMessage?) {
        if let message = errorMessage {
            errorFetchingIssues(delegate: delegate,
                                errorMessage: message)
            return
        }

        displayIssues(delegate: delegate)
    }

    func fillIssueData(withDelegate delegate: IssueTableViewCellDelegate,
                       forCellAt index: Int) {
        let issue = issuesList[index]
        delegate.setIssueCell(withTitle: issue.title,
                              andStatus: issue.status)
    }

    func getNumberOfIssues() -> Int {
        return issuesList.count
    }

    func getIssuePageViewModel(forIndex index: Int) -> IssuePageViewModel {
        let issue = issuesList[index]
        return IssuePageViewModel(issue: issue,
                                  provider: provider)
    }

    // MARK: - Private methods

    private func displayIssues(delegate: IssuesTableViewDelegate) {
        delegate.reloadIssuesList()
    }

    private func errorFetchingIssues(delegate: IssuesTableViewDelegate,
                                     errorMessage: String) {
        issuesList.removeAll()
        delegate.showErrorMessage(errorMessage)
    }

    private func decodeToList(fromResult result: Result<Response, MoyaError>) -> ErrorMessage? {
        switch result {
        case .failure(let error):
            issuesList.removeAll()
            return error.errorDescription
        case .success(let response):
            return decodeOrCry(response)
        }
    }

    private func decodeOrCry(_ respose: Response) -> ErrorMessage? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601

        do {
            issuesList = try respose.map([Issue].self,
                                         using: jsonDecoder)
            return nil
        } catch {
            issuesList.removeAll()
            return (error as? MoyaError)?.errorDescription
        }
    }
}
