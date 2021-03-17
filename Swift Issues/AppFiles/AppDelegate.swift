import UIKit
import Moya

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let issuesViewModel = IssuesViewModel(provider: MoyaProvider<GitHub>())
        let issuesTableViewController = IssuesTableViewController(issuesViewModel: issuesViewModel)
        window!.rootViewController = UINavigationController(rootViewController: issuesTableViewController)
        window!.makeKeyAndVisible()
        return true
    }
}
