@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfSentenceBackward_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceBackward(startingAt: caretLocation)
    }
    
}


extension FT_beginningOfSentenceBackward_OnEmptyLines_Tests {
    
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
    
    func test_that_it_does_not_get_stuck_in_the_middle_of_multiple_EmptyLines() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 62)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_on_an_EmptyLine_and_the_text_starts_by_multiple_EmptyLines_then_it_goes_to_the_start() {
        let text = """





plenty of empty lines
above
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_it_does_not_skip_the_beginning_of_the_sentence_above() {
        let text = """
another bug

   of course
 hehe



this is some more text
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 33)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 16)
    }
    
}


// bugs found
extension FT_beginningOfSentenceBackward_OnEmptyLines_Tests {
    
    func test_that_it_does_not_skip_EmptyLines_in_some_cases() {
        let text = """
so that's a case

where it skips

empty lines!
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 33)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 18)
    }
    
    func test_that_if_there_are_BlankLines_between_EmptyLines_then_it_stops_on_the_EmptyLine_right_before_the_BlankLines() {
        let text = """
so below there's some empty lines
but also a two blank line in the middle!





          
   


hehe
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 96)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 79)
    }

}
