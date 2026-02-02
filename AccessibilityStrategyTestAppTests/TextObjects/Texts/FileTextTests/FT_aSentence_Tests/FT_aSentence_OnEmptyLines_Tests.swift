@testable import AccessibilityStrategy
import XCTest


class FT_aSentence_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_aSentence_OnEmptyLines_Tests {
    
    func test_that_for_an_EmptyLine_it_returns_the_correct_range() {
        let text = ""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 0) 
    }

}


// TODO: already found some EL that fail lol. single EL
