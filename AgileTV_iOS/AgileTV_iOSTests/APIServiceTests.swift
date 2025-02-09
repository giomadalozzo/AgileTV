import XCTest
import Alamofire
@testable import AgileTV_iOS

// APIService Unit Tests
class APIServiceTests: XCTestCase {

    var apiService: APIService!
    var session: Session!

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

        session = Session(configuration: configuration)
        apiService = APIService(session: session)
    }

    override func tearDown() {
        apiService = nil
        session = nil
        MockURLProtocol.responseData = nil
        MockURLProtocol.responseError = nil
        MockURLProtocol.responseStatusCode = 200
        super.tearDown()
    }

    func loadMockJSON(from fileName: String) -> Data? {
        guard let path = Bundle(for: APIServiceTests.self).path(forResource: fileName, ofType: "json") else {
            XCTFail("File \(fileName).json not found")
            return nil
        }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }

    // Testing FetchRepositories returning 200
    func testFetchRepositories_Success() async throws {

        // Given: JSON Response
        guard let mockJSON = loadMockJSON(from: "RepositoriesMock") else { return }

        MockURLProtocol.responseData = mockJSON

        // When: Calling fetchRepositories
        do {
            let repositories = try await apiService.fetchRepositories(for: "giomadalozzo")

            // Then: Repositories should be updated matching the JSON
            XCTAssertEqual(repositories.count, 1)
            XCTAssertEqual(repositories.first?.name, "AnimeXtreme")
            XCTAssertEqual(repositories.first?.owner.avatarURL, "https://avatars.githubusercontent.com/u/66277269?v=4")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // Testing FetchRepositories returning 404
    func testFetchRepositories_NotFound() async {

        // Given: Status code 404
        MockURLProtocol.responseStatusCode = 404

        // When: Calling fetchRepositories
        do {
            _ = try await apiService.fetchRepositories(for: "invaliduser")
            XCTFail("Expected an error, but everything went just fine")
        } catch let error as APIError {

            // Then: Should return an not found error
            XCTAssertEqual(error, APIError.notFound)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // Testing FetchRepositories returning 500 (generic error)
    func testFetchRepositories_GenericError() async {

        // Given: Status code 500
        MockURLProtocol.responseStatusCode = 500

        // When: Calling fetchRepositories
        do {
            _ = try await apiService.fetchRepositories(for: "giomadalozzo")
            XCTFail("Expected an error, but everything went just fine")
        } catch let error as APIError {

            // Then: Should return an generic error
            XCTAssertEqual(error, APIError.genericError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // Testing FetchRepositories with timeout error
    func testFetchRepositories_Timeout() async {

        // Given: Timed out response error
        MockURLProtocol.responseError = URLError(.timedOut)

        // When: Calling fetchRepositories
        do {
            _ = try await apiService.fetchRepositories(for: "giomadalozzo")
            XCTFail("Expected timeout, but everything went just fine")
        } catch {

            // Then: Should return an timeout error
            XCTAssertNotNil(error, "Timeout error returned")
        }
    }

    // Testing FetchAvatar returning 200
    func testFetchAvatar_Success() async throws {

        // Given: JSON Response
        guard let mockJSON = loadMockJSON(from: "UserMock") else { return }

        MockURLProtocol.responseData = mockJSON

        // When: Calling fetchAvatar
        do {
            let user = try await apiService.fetchAvatar(for: "giomadalozzo")

            // Then: AvatarURL should be updated matching the JSON
            XCTAssertEqual(user.avatarURL, "https://avatars.githubusercontent.com/u/66277269?v=4")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // Testing FetchAvatar returning 404
    func testFetchAvatar_NotFound() async {
        MockURLProtocol.responseStatusCode = 404

        do {
            _ = try await apiService.fetchAvatar(for: "invaliduser")
            XCTFail("Expected an error, but everything went just fine")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.notFound)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // Testing FetchAvatar with timeout error
    func testFetchAvatar_Timeout() async {

        // Given: Timed out response error
        MockURLProtocol.responseError = URLError(.timedOut)

        // When: Calling fetchAvatar
        do {
            _ = try await apiService.fetchAvatar(for: "giomadalozzo")
            XCTFail("Expected timeout, but everything went just fine")
        } catch {

            // Then: Should return an timeout error
            XCTAssertNotNil(error, "Timeout error returned")
        }
    }
}

