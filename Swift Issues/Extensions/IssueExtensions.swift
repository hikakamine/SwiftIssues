import Foundation

extension Issue {
    private var userLogin: String { self.user?.login ?? "[unknown user]" }
    private var creationDate: String { self.createdAt?.formatted() ?? "[unknown date]" }

    func getIssueCreationDetails() -> String {
        "User \(self.userLogin) created the issue in \(self.creationDate)"
    }
}
