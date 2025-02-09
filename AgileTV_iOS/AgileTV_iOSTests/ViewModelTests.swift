import XCTest
import Alamofire
@testable import AgileTV_iOS

@MainActor
class ViewModelTests: XCTestCase {

    var viewModel: ViewModel!
    var apiService: APIService!

    override func setUp() {
        super.setUp()

        // Creating configuration using MockURLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)

        // Using custom Session on the APIService
        apiService = APIService(session: session)
        viewModel = ViewModel()
    }

    override func tearDown() {
        viewModel = nil
        apiService = nil
        super.tearDown()
    }

    func loadMockJSON(from fileName: String) -> Data? {
        guard let path = Bundle(for: APIServiceTests.self).path(forResource: fileName, ofType: "json") else {
            XCTFail("File \(fileName).json not found")
            return nil
        }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }

    func testFetchRepositories_Success() async {
        // Given: Status code 200
        guard let mockJSON = loadMockJSON(from: "RepositoriesMock") else { return }

        MockURLProtocol.responseData = mockJSON
        MockURLProtocol.responseError = nil
        MockURLProtocol.responseStatusCode = 200

        // When: Calling view model's fetchRepositories
        await viewModel.fetchRepositories(for: "giomadalozzo")

        // Then: Response should match JSON
        XCTAssertFalse(viewModel.repositories.isEmpty, "Repositories should not be empty")
        XCTAssertEqual(viewModel.avatarURL, "https://avatars.githubusercontent.com/u/66277269?v=4", "URL should match")
        XCTAssertTrue(viewModel.avatarLoaded, "Avatar has been loaded, should be true")
        XCTAssertNil(viewModel.error, "Error should be nil on success")
    }

    func testFetchRepositories_NotFound() async {

        // Given: Status code 404
        MockURLProtocol.responseStatusCode = 404

        // When: Calling view model's fetchRepositories
        do {
                _ = try await apiService.fetchRepositories(for: "test")
                XCTFail("Expected error but got success response")
            } catch let error as APIError {

                // Then: Should return a not found error
                XCTAssertEqual(error, .notFound, "Expected APIError.notFound but got \(error)")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
    }

    func testFetchRepositories_GenericError() async {

        // Given: Status code 500
        MockURLProtocol.responseStatusCode = 500

        // When: Calling view model's fetchRepositories
        do {
                _ = try await apiService.fetchRepositories(for: "test")
                XCTFail("Expected error but got success response")
            } catch let error as APIError {

                // Then: Should return a generic error
                XCTAssertEqual(error, .genericError, "Expected APIError.notFound but got \(error)")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
    }
}
