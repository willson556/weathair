import XCTest
@testable import WeathAirShared

final class WeathAir_SharedTests: XCTestCase {
    func TestFetchObservations() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let zipCode = 95136
        let service = ObservationAPIService(url: "http://127.0.0.1:8000/api/v1/observations-for-zip/")
        let expectation = XCTestExpectation(description: "Get api data")
        
        service.getObservationsForZipCode(zipCode: zipCode) { (error, observations) in
            XCTAssertNotNil(observations)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

    static var allTests = [
        ("testExample", TestFetchObservations),
    ]
}
