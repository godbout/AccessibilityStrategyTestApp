@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfSentenceForward_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceForward(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_beginningOfSentenceForward_OnEmptyLines_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 0)
    }
    
}


// TextViews
// surrounded by EmptyLines
extension FT_beginningOfSentenceForward_OnEmptyLines_Tests {
    
    func test_that_if_the_caret_is_on_the_last_EmptyLine_then_it_does_not_move() {
        let text = """
this move doesn't bip
but of course at the last empty line
it will not move

"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 76)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 76)
    }
       
    func test_that_it_does_not_get_stuck_in_the_middle_of_multiple_EmptyLines() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 62)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 67)
    }
    
    func test_that_if_the_caret_is_on_an_EmptyLine_and_the_text_ends_by_multiple_EmptyLines_then_it_goes_to_the_end() {
        let text = """
plenty of empty lines
below







"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 29)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 34)
    }
    
}


// bugs found
extension FT_beginningOfSentenceForward_OnEmptyLines_Tests {

    func test_that_if_the_caret_is_on_an_EmptyLine_and_the_next_line_is_not_empty_then_it_stops_there() {
        let text = """
so that's a case

where it skips

empty lines!
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 18)
    }
    
    func test_that_if_the_caret_is_on_an_EmptyLine_and_the_next_line_is_not_empty_then_it_stops_at_the_first_NonBlank_of_that_line() {
        let text = """
so that's a case

  where it skips

empty lines!
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 20)
    }

    func test_that_if_there_are_BlankLines_between_EmptyLines_then_it_stops_on_the_EmptyLine_right_after_the_BlankLines() {
        let text = """
so below there's some empty lines
but also a two blank line in the middle!





          
   


hehe
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 77)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 95)
    }
    
}
