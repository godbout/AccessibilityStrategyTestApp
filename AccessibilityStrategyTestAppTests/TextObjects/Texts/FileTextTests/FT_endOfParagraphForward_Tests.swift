@testable import AccessibilityStrategy
import XCTest


class FT_endOfParagraphForward_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_endOfParagraphForward_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfParagraphForwardLocation = fileText.endOfParagraphForward(startingAt: 0)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_does_not_move() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""

        let fileText = FileText(end: text.utf16.count, value: text)
       	let endOfParagraphForwardLocation = fileText.endOfParagraphForward(startingAt: 54)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 54)
    }
    
}


// Both
extension FT_endOfParagraphForward_Tests {
    
    
    func test_that_if_the_text_does_not_have_linefeed_then_it_stops_before_the_last_character() {
        let text = "like a TextField really"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfParagraphForwardLocation = fileText.endOfParagraphForward(startingAt: 2)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 22)
    }
    
}


// TextViews
extension FT_endOfParagraphForward_Tests {
    
    func test_that_it_can_go_to_the_end_of_the_current_paragraph() {
        let text = """
some poetry
that is beautiful

and some more blah blah
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfParagraphForwardLocation = fileText.endOfParagraphForward(startingAt: 6)

        XCTAssertEqual(endOfParagraphForwardLocation, 30)
    }
    
    func test_that_if_the_caret_is_already_on_an_empty_line_it_skips_all_the_consecutive_empty_lines() {
        let text = """
hello



some more
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfParagraphForwardLocation = fileText.endOfParagraphForward(startingAt: 6)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 17)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_endOfParagraphForward_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
yes 🐰️🐰️🐰️🐰️ this can happen🐰️🐰️ when the



🐰️🐰️car🐰️et is after the last character🐰️🐰️🐰️
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfParagraphForwardLocation = fileText.endOfParagraphForward(startingAt: 13)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 48)
    }
    
}
