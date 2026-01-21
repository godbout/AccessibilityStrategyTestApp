@testable import AccessibilityStrategy
import XCTest


// see next for blah blah
class FT_previousNonBlank_Tests: XCTestCase {}


// TextViews
extension FT_previousNonBlank_Tests {
    
    func test_that_on_FileText_when_it_reaches_the_beginning_of_a_FileLine_then_it_returns_the_previous_Newline_because_Newline_at_nonBlanks() {
        let text = """
so even if this is a whole text
    with multiple lines, the func stays
on its line because linefeed blah blah
"""        
        let fileText = FileText(end: text.utf16.count, value: text)
        
        let nextNonBlankLocation = fileText.previousNonBlank(startingAt: 35)
        
        XCTAssertEqual(nextNonBlankLocation, 31)
    }
       
}
