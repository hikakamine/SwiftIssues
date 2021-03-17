import Foundation

protocol IssueTableViewCellDelegate {

    func setIssueCell(withTitle title: String,
                      andStatus status: String)
}
