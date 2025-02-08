import Foundation

enum APIError: Int, Identifiable {

    case notFound = 404
    case genericError
    
    var id: Int { self.rawValue }

    var errorDescription: String {
        switch self {
        case .genericError:
            return "A network error has occurred. Check your Internet connection and try again later."
        case .notFound:
            return "User not found. Please enter another name."
        }
    }
}
