@testable import AccessibilityStrategy
import XCTest


// see FL firstNonBlank for blah blah
// plus because lots of tests are done there already, here we're gonna
// test for FileTexts, which means basically make sure it stops at Newlines
class FT_firstNonBlank_Tests: XCTestCase {}


extension FT_firstNonBlank_Tests {
    
    func test_that_it_stops_at_Newlines() throws {
        let text = """



"""
        let fileText = try XCTUnwrap(
            FileText(end: text.utf16.count, value: text)
        )
        
        XCTAssertEqual(fileText.firstNonBlank, 0)
    }
    
}
