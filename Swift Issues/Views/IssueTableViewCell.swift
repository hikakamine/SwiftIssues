import UIKit

class IssueTableViewCell: UITableViewCell {

    // MARK: UI Properties

    lazy var status: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        addSubview(label)
        return label
    }()

    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        addSubview(label)
        return label
    }()

    // MARK: Overriden methods

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

// MARK: - Layout setup
extension IssueTableViewCell {

    private func setupLayout() {
        setupStatusLabelConstraints()
        setupTitleLabelConstraints()
    }

    private func setupStatusLabelConstraints() {
        NSLayoutConstraint.activate([
            self.status.topAnchor.constraint(equalTo: self.topAnchor,
                                            constant: 4),
            self.status.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: 16),
            self.status.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                 constant: -16),
            self.status.heightAnchor.constraint(equalToConstant: 16)])
    }

    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: status.bottomAnchor,
                                            constant: 4),
            self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: 16),
            self.title.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                 constant: -16),
            self.title.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                               constant: -4)])
    }
}

// MARK: - Issue Table View Cell Delegate
extension IssueTableViewCell: IssueTableViewCellDelegate {

    func setIssueCell(withTitle title: String,
                      andStatus status: String) {
        self.title.text = title
        self.status.text = status
    }
}
