import UIKit

typealias ErrorMessage = String

protocol UIViewControllerDelegate {

    func showErrorMessage(_ message: ErrorMessage)
}

// MARK: - UIViewController Delegate
extension UIViewController: UIViewControllerDelegate {

    func showErrorMessage(_ message: ErrorMessage) {
        print(message)
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
