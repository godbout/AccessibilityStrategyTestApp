@testable import AccessibilityStrategy
import XCTest


class FT_endOfParagraphForward_NormalSetting_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.endOfParagraphForward(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_endOfParagraphForward_NormalSetting_Tests {
    
    func test_that_if_the_text_does_not_have_linefeed_then_it_stops_before_the_last_character() {
        let text = "like a TextField really"

        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 22)
    }
    
}


// TextViews
extension FT_endOfParagraphForward_NormalSetting_Tests {
    
    func test_that_it_can_go_to_the_end_of_the_current_paragraph() {
        let text = """
some poetry
that is beautiful

and some more blah blah
"""

        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 6)

        XCTAssertEqual(endOfParagraphForwardLocation, 30)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_endOfParagraphForward_NormalSetting_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
yes 🐰️🐰️🐰️🐰️ this can happen🐰️🐰️ when the



🐰️🐰️car🐰️et is after the last character🐰️🐰️🐰️
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 13)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 48)
    }
    
}
