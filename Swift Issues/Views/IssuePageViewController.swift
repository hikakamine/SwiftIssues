import UIKit

class IssuePageViewController: UIViewController {

    // MARK: UI properties

    lazy var userAvatar: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        return imageView
    }()

    lazy var issueCreationInfo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }()

    lazy var issueTitle: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .black
        view.addSubview(textView)
        return textView
    }()

    lazy var issueDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .gray
        view.addSubview(textView)
        return textView
    }()

    lazy var linkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View Issue on Github", for: .normal)
        button.setTitle("View Issue on Github", for: .selected)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemBlue, for: .selected)
        view.addSubview(button)
        return button
    }()

    // MARK: View Model

    private let issuePageViewModel: IssuePageViewModel

    // MARK: Initialization

    init(issuePageViewModel: IssuePageViewModel) {
        self.issuePageViewModel = issuePageViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupLayout()
        setIssuePageData()
        setupLinkButtonAction()
    }
}

// MARK: - Private methods
extension IssuePageViewController {

    private func setupViewController() {
        title = "Issue Details"
        view.backgroundColor = .white
    }

    private func setupLayout() {
        setupUserAvatarConstraints()
        setupIssueCreationInfoConstraints()
        setupIssueTitleConstraints()
        setupLinkButtonConstraints()
        setupIssueDescriptionConstraints()
    }

    private func setupUserAvatarConstraints() {
        NSLayoutConstraint.activate([
            userAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            userAvatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            userAvatar.heightAnchor.constraint(equalToConstant: 64),
            userAvatar.widthAnchor.constraint(equalToConstant: 64)
        ])
    }

    private func setupIssueCreationInfoConstraints() {
        NSLayoutConstraint.activate([
            issueCreationInfo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            issueCreationInfo.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 8),
            issueCreationInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            issueCreationInfo.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    private func setupIssueTitleConstraints() {
        NSLayoutConstraint.activate([
            issueTitle.topAnchor.constraint(equalTo: issueCreationInfo.bottomAnchor, constant: 8),
            issueTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            issueTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            issueTitle.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    private func setupIssueDescriptionConstraints() {
        NSLayoutConstraint.activate([
            issueDescription.topAnchor.constraint(equalTo: issueTitle.bottomAnchor, constant: 8),
            issueDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            issueDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            issueDescription.bottomAnchor.constraint(equalTo: linkButton.topAnchor, constant: -8)
        ])
    }

    private func setupLinkButtonConstraints() {
        NSLayoutConstraint.activate([
            linkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            linkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            linkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            linkButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setIssuePageData() {
        issuePageViewModel.fillIssueDetailsData(withDelegate: self)
        issuePageViewModel.fetchUserAvatar(completionHandler: { [unowned self] result in
            DispatchQueue.main.async {
                self.issuePageViewModel.setUserAvatar(withDelegate: self,
                                                        orShowError: result)
            }
        })
    }

    private func setupLinkButtonAction() {
        linkButton.addTarget(self,
                             action: #selector(function),
                             for: .touchUpInside)
    }

    @objc private func function() {
        issuePageViewModel.openIssuePage(withDelegate: self)
    }
}

// MARK: - Issue Page View Delegate
extension IssuePageViewController: IssuePageViewDelegate {

    func setIssueInformation(title: String,
                             creationInfo: String,
                             description: String) {
        issueTitle.text = title
        issueCreationInfo.text = creationInfo
        issueDescription.text = description
    }

    func setUserAvatar(fromData data: Data) {
        userAvatar.image = data.asImage
    }

    func openIssueUrl(url: URL) {
        UIApplication.shared.open(url)
    }
}
