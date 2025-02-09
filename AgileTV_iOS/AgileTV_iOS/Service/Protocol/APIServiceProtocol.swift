import Foundation

protocol APIServiceProtocol {
    func fetchRepositories(for username: String) async throws -> [Repository]
    func fetchAvatar(for username: String) async throws -> User
}
