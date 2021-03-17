import Foundation

extension Issue {

    static var completeIssue: Issue {
        get {
            let user = User(login: "userLogin",
                            id: 10,
                            nodeId: "nodeId",
                            avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10?v=4"))
            let date = Date(timeIntervalSince1970: 1615388400)
            return createIssue(withUser: user,
                               date: date,
                               andURL: URL(string: "https://github.com/apple/swift/pull/1"))
        }
    }

    static var incompleteIssue: Issue {
        get {
            createIssue(withUser: nil,
                        date: nil,
                        andURL: nil)
        }
    }

    private static func createIssue(withUser user: User?,
                                    date: Date?,
                                    andURL url: URL?) -> Issue {
        return Issue(id: 1,
                     htmlUrl: url,
                     status: "closed",
                     title: "Title",
                     body: "Description",
                     user: user,
                     createdAt: date)
    }
}
