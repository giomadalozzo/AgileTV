import Foundation
import Alamofire

class ViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isEmpty: Bool = false
    @Published var avatarURL: String? = nil
    @Published var avatarLoaded: Bool = false

    // Fetch the repositories from the API main endpoint
    // - Parameter username: String containing the searched username
    // - Updates avatarLoaded, avatarURL, isEmpty and repositories
    func fetchRepositories(username: String) {
        let url = "https://api.github.com/users/\(username)/repos"
        
        AF.request(url).responseDecodable(of: [Repository].self) { response in
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
                    print("Error found: \(error.localizedDescription)")
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
        
        AF.request(url).responseDecodable(of: User.self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let user):
                    self.avatarURL = user.avatarURL
                    self.isEmpty = self.repositories.isEmpty
                    self.avatarLoaded = true
                case .failure(let error):
                    print("Error found: \(error.localizedDescription)")
                }
            }
        }
    }
}
