import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(WeathAir_SharedTests.allTests),
    ]
}
#endif
