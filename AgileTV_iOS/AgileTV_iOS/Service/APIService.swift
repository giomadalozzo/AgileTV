import Foundation
import Alamofire

// APIService class: responsable for doing the requests into the API endpoint
// - Timeout configuration inside the init()
// - Error cases treated (200..<300, 404 and generic errors)
/// Using APIServiceProtocol and init with Session to be able to unit test the APIService class
class APIService: APIServiceProtocol {
    
    static let shared = APIService() // Singleton for reusage

    private let session: Session

    init(session: Session = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 25
            configuration.timeoutIntervalForResource = 25
            return Session(configuration: configuration)
        }()) {
            self.session = session
        }
    

    func fetchRepositories(for username: String) async throws -> [Repository] {
        let url = "https://api.github.com/users/\(username)/repos"

        return try await withCheckedThrowingContinuation { continuation in
            session.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [Repository].self) { response in
                    switch response.result {
                    case .success(let repositories):
                        continuation.resume(returning: repositories)
                    case .failure(let error):
                        let apiError = APIError.map(error)
                        continuation.resume(throwing: apiError)
                    }
                }
        }
    }

    func fetchAvatar(for username: String) async throws -> User {
        let url = "https://api.github.com/users/\(username)"

        return try await withCheckedThrowingContinuation { continuation in
            session.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: User.self) { response in
                    switch response.result {
                    case .success(let repositories):
                        continuation.resume(returning: repositories)
                    case .failure(let error):
                        let apiError = APIError.map(error)
                        continuation.resume(throwing: apiError)
                    }
                }
        }
    }
}
