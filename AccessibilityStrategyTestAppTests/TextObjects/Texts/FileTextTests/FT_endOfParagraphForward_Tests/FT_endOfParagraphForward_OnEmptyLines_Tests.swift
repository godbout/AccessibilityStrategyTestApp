@testable import AccessibilityStrategy
import XCTest


class FT_endOfParagraphForward_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.endOfParagraphForward(startingAt: caretLocation)
    }
    
}


extension FT_endOfParagraphForward_OnEmptyLines_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""

        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_EmptyLine_then_it_does_not_move() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""

        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 54)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 54)
    }

    func test_that_if_the_caret_is_already_on_an_EmptyLine_it_skips_all_the_consecutive_EmptyLines() {
        let text = """
hello



some more

hoho
"""

        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 19)
    }
    
}
