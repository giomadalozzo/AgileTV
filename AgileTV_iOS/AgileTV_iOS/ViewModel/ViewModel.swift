import Foundation
import Alamofire

// I chose to use Alamofire for the HTTP request because it simplifies error handling
// and the direct decoding of data into structs.
@MainActor
class ViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var avatarURL: String? = nil
    @Published var avatarLoaded: Bool = false
    @Published var error: APIError? = nil

    // Fetch the repositories from the API main endpoint
    // - Parameter username: String containing the searched username
    // - Updates avatarLoaded, avatarURL, isEmpty and repositories
    func  fetchRepositories(for username: String) async {
        do {     
            self.repositories = try await APIService.shared.fetchRepositories(for: username)

            // If there is no repositories, we need to do another request to get the avatar URL
            if self.repositories.isEmpty {
                await self.fetchAvatar(for: username)
            } else {
                self.avatarURL = self.repositories.first?.owner.avatarURL
                self.avatarLoaded = true
            }
        } catch let error as APIError {
            self.error = error
        } catch {
            self.error = APIError.genericError
        }
    }


    // Fetch the avatar URL from the other API endpoint
    // - Parameter username: String containing the searched username
    // - Updates avatarLoaded, avatarURL
    /// It is needed, because when the user has no repositories on GitHub, the API returns an empty JSON when using fetchRepositories function
    private func fetchAvatar(for username: String) async {
        do {
            self.avatarURL = try await APIService.shared.fetchAvatar(for: username).avatarURL
            self.avatarLoaded = true
        } catch let error as APIError {
            self.error = error
        } catch {
            self.error = APIError.genericError
        }
    }
}
