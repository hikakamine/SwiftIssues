import Foundation

struct User {
    var login: String
    var id: Int
    var nodeId: String
    var avatarUrl: URL?
}

// MARK: - Decodable protocol
extension User: Decodable {
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
    }
}
