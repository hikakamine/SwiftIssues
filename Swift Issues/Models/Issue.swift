import Foundation

struct Issue {
    var id: Int
    var htmlUrl: URL?
    var status: String
    var title: String
    var body: String
    var user: User?
    var createdAt: Date?
}

// MARK: - Decodable protocol
extension Issue: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case htmlUrl = "html_url"
        case status = "state"
        case title = "title"
        case body = "body"
        case user = "user"
        case createdAt = "created_at"
    }
}
