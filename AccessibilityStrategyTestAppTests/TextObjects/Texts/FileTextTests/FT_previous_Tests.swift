@testable import AccessibilityStrategy
import XCTest

// see next for blah blah
class FT_previous_Tests: XCTestCase {}


// TextViews
extension FT_previous_Tests {
    
    func test_that_it_searches_the_whole_text_before_the_caretLocation_rather_than_just_the_line() {
        let text = """
so if i get this right that shits should search
on its own line else it's gay
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.previous("a", before: 64)
        
        XCTAssertEqual(characterFoundLocation, 43)
    }
       
}
