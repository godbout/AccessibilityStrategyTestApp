@testable import AccessibilityStrategy
import XCTest


// TODO: HEHE
// see Backward for blah blah
class FT_beginningOfSentenceBackward_OnEmptyOrBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceBackward(startingAt: caretLocation)
    }
    
}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_beginningOfSentenceBackward_OnEmptyOrBlankLines_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_on_the_last_EmptyLine_it_goes_to_the_beginning_of_the_sentence() {
        let text = """
this move doesn't bip
but of course at the last empty line
it will. not move

"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 77)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 68)
    }
    
}


// TextViews
extension FT_beginningOfSentenceBackward_OnEmptyOrBlankLines_Tests {
    
    func test_that_it_does_not_get_stuck_in_the_middle_of_multiple_emptyLines() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 62)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_on_an_emptyLine_and_the_text_starts_by_multiple_emptyLines_then_it_goes_to_the_start() {
        let text = """





plenty of empty lines
above
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
}
