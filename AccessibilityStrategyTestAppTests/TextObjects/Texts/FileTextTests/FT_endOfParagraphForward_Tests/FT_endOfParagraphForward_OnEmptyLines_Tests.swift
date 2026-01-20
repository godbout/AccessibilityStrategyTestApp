@testable import AccessibilityStrategy
import XCTest


class FT_endOfParagraphForward_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.endOfParagraphForward(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_endOfParagraphForward_OnEmptyLines_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 0)
    }
    
}


// TextViews
// basic
extension FT_endOfParagraphForward_OnEmptyLines_Tests {

    func test_that_it_does_not_get_stuck_at_a_NonEmptyLine() {
        let text = """
so here's some text
and more

and now the next NonEmptyLine

and above an EL!
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 29)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 60)
    }
    
    func test_that_it_does_not_get_stuck_at_multiple_NonEmptyLines() {
        let text = """
so here's some text
and more

and now the next NonEmptyLines
and now the next NonEmptyLines
and now the next NonEmptyLines


last line hehe
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 29)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 123)
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
    
}


// TextViews
// surrounded by EmptyLines
extension FT_endOfParagraphForward_OnEmptyLines_Tests {

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


// TextViews
// surrounded by BlankLines
extension FT_endOfParagraphForward_OnEmptyLines_Tests {
    
    func test_that_if_the_caret_is_already_on_an_EmptyLine_it_skips_all_the_consecutive_BlankLines() {
        let text = """
a line and then EL and then BLs

     
     
a line of text before EL

hoho
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 32)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 70)
    }
    
}


// bug found
extension FT_endOfParagraphForward_OnEmptyLines_Tests {
    
    func test_that_it_stops_at_the_first_end_of_paragraph_found_and_not_at_others_down_the_text() {
        let text = """
some poetry
that is beautiful


and some more blah blah


some more paragraphs!

and some more!
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 30)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 56)
    }
    
}
