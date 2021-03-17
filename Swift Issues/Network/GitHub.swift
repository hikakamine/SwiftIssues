import Moya

enum GitHub {
    case issues
    case avatar(url: URL)
}

extension GitHub: TargetType {
    var baseURL: URL {
        switch self {
            case .issues:
                return URL(string: "https://api.github.com/repos/apple/swift")!
            case .avatar(let url):
                return url
        }
    }

    var path: String {
        switch self {
            case .issues: return "/issues"
            case .avatar(_): return ""
        }
    }

    var method: Moya.Method {
        switch self {
            case .issues: return .get
            case .avatar(_): return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        switch self {
            case .issues:
                return ["Content-Type": "application/json"]
            case .avatar(_):
                return nil
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
