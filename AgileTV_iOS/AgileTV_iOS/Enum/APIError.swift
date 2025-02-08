import Foundation
import Alamofire

enum APIError: Error, LocalizedError, Identifiable {
    case notFound
    case genericError

    var id: String { localizedDescription }

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "User not found. Please enter another name."
        case .genericError:
            return "A network error has occurred. Check your Internet connection and try again later."
        }
    }

    static func map(_ error: AFError) -> APIError {
        if let statusCode = error.responseCode {
            switch statusCode {
            case 404:
                return .notFound
            default:
                return .genericError
            }
        }

        if error.isSessionTaskError {
            return .genericError
        }

        return .genericError
    }
}
