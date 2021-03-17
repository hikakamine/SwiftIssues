import Foundation

protocol IssuePageViewDelegate: UIViewControllerDelegate {

    func setIssueInformation(title: String,
                             creationInfo: String,
                             description: String)

    func setUserAvatar(fromData data: Data)

    func openIssueUrl(url: URL)
}
