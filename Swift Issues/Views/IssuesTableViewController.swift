import UIKit

class IssuesTableViewController: UITableViewController {

    private let issueCellIdentifier = "IssueCellIdentifier"

    private var issuesViewModel: IssuesViewModel

    // MARK: Initialization

    init(issuesViewModel: IssuesViewModel) {
        self.issuesViewModel = issuesViewModel
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getIssues()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return issuesViewModel.getNumberOfIssues()
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: issueCellIdentifier,
                                                 for: indexPath) as! IssueTableViewCell
        issuesViewModel.fillIssueData(withDelegate: cell as IssueTableViewCellDelegate,
                                      forCellAt: indexPath.row)
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let issuePageViewModel = issuesViewModel.getIssuePageViewModel(forIndex: indexPath.row)
        let issuePageViewController = IssuePageViewController(issuePageViewModel: issuePageViewModel)
        navigationController?.pushViewController(issuePageViewController,
                                                 animated: true)
    }

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(96)
    }
}

// MARK: - Private methods
extension IssuesTableViewController {

    private func setupTableView() {
        tableView.register(IssueTableViewCell.self,
                           forCellReuseIdentifier: issueCellIdentifier)
        title = "Swift Issues"
    }

    private func getIssues() {
        issuesViewModel.fetchIssues { [unowned self] errorMessage in
            DispatchQueue.main.async {
                self.issuesViewModel.executeFetchResult(delegate: self,
                                                        errorMessage: errorMessage)
            }
        }
    }
}

// MARK: - Issues Table View Delegate
extension IssuesTableViewController: IssuesTableViewDelegate {

    func reloadIssuesList() {
        tableView.reloadData()
    }
}
