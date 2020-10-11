import XCTest
@testable import WeathAir_Shared

final class WeathAir_SharedTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(WeathAir_Shared().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
