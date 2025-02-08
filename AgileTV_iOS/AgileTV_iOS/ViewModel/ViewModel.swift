import Foundation
import Alamofire

// I chose to use Alamofire for the HTTP request because it simplifies error handling
// and the direct decoding of data into structs.
class ViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isEmpty: Bool = false
    @Published var avatarURL: String? = nil
    @Published var avatarLoaded: Bool = false
    @Published var error: APIError? = nil

    // Fetch the repositories from the API main endpoint
    // - Parameter username: String containing the searched username
    // - Updates avatarLoaded, avatarURL, isEmpty and repositories
    func fetchRepositories(username: String) {
        let url = "https://api.github.com/users/\(username)/repos"
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Repository].self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let repos):
                    self.repositories = repos
                    if let firstRepo = self.repositories.first {
                        self.avatarURL = firstRepo.owner.avatarURL
                        self.avatarLoaded = true
                    } else {
                        self.fetchAvatar(username: username)
                    }
                case .failure(let error):
                    if let code = error.responseCode {
                        self.error = APIError(rawValue: code)
                    }
                }
            }
        }
    }
    

    // Fetch the avatar URL from the other API endpoint
    // - Parameter username: String containing the searched username
    // - Updates avatarLoaded, avatarURL and isEmpty
    /// It is needed, because when the user has no repositories on GitHub, the API returns an empty JSON when using fetchRepositories function
    private func fetchAvatar(username: String) {
        let url = "https://api.github.com/users/\(username)"
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: User.self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let user):
                    self.avatarURL = user.avatarURL
                    self.isEmpty = self.repositories.isEmpty
                    self.avatarLoaded = true
                case .failure(let error):
                    if let code = error.responseCode {
                        self.error = APIError(rawValue: code)
                    }
                }
            }
        }
    }
}
