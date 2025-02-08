import Foundation

struct Repository: Codable {
    let name: String
    let owner: User
    let language: String?

    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case language
    }
}
