import XCTest
import Alamofire
@testable import AgileTV_iOS

class APIErrorTests: XCTestCase {

    func testErrorDescriptions() {
        XCTAssertEqual(APIError.notFound.errorDescription, "User not found. Please enter another name.")
        XCTAssertEqual(APIError.genericError.errorDescription, "A network error has occurred. Check your Internet connection and try again later.")
    }

    func testErrorMapping() {
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 404))
        let mappedError = APIError.map(afError)
        XCTAssertEqual(mappedError, .notFound)
    }
}
