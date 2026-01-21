@testable import AccessibilityStrategy
import XCTest


// see next for blah blah
class FT_nextNonBlank_Tests: XCTestCase {}


// TextViews
extension FT_nextNonBlank_Tests {
    
    func test_that_even_on_the_whole_text_the_nextNonBlank_stops_at_FileLines_because_Newline_is_actually_a_nonBlank() {
        let text = """
so even if this is a whole text
with multiple lines, the func stays
on its line because linefeed blah blah
"""        
        let fileText = FileText(end: text.utf16.count, value: text)
        
        let nextNonBlankLocation = fileText.nextNonBlank(after: 66)
        
        XCTAssertEqual(nextNonBlankLocation, 67)
    }
       
}
