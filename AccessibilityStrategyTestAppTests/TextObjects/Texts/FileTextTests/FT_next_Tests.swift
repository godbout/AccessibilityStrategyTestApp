@testable import AccessibilityStrategy
import XCTest


// most of the tests are in FL, as a FL is a FT of one line :D
// here we just check the case specific to TextViews, which is that it searches the
// whole text (after or before) rather than just the Line.
class FT_next_Tests: XCTestCase {}


// TextViews
extension FT_next_Tests {
    
    func test_that_it_searches_the_whole_text_after_the_caretLocation_rather_than_just_the_line() {
        let text = """
so if i get this right that shits should search
on its own line else it's gay
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.next("y", after: 3)
        
        XCTAssertEqual(characterFoundLocation, 76)
    }
       
}
