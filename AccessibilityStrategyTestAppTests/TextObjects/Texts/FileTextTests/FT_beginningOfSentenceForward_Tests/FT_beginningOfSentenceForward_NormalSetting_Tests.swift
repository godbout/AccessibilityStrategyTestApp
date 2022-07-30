@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfSentenceForward_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceForward(startingAt: caretLocation)
    }
    
}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_beginningOfSentenceForward_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_on_the_last_EmptyLine_then_it_does_not_move() {
        let text = """
this move doesn't bip
but of course at the last empty line
it will not move

"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 76)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 76)
    }
    
}


// both
extension FT_beginningOfSentenceForward_Tests {

    func test_that_if_the_text_is_just_one_word_then_it_goes_to_the_endLimit_of_the_text() {
        let text = "dumb"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 3)
    }
    
    func test_that_it_detects_the_dot_as_an_end_of_sentence() {
        let text = "dumb. and dumber"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 6)
    }
    
    func test_that_it_skips_over_multiple_spaces() {
        let text = "dumb. and.                      dumber"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 32)
    }
    
    func test_that_it_detects_the_exclamation_mark_as_an_end_of_sentence() {
        let text = "dumb. and!    dumber"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 14)
    }
        
    func test_that_it_detects_the_interrogation_mark_as_an_end_of_sentence() {
        let text = "dumb. and dumber?  is that true"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 19)
    }
        
    func test_that_it_requires_at_least_one_space_after_the_delimiting_punctuation() {
        let text = "dumb.anddumber?is  that true"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 27)
    }
        
    func test_that_an_infinite_number_of_closing_parentheses_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = "wow ok so that's.))))   kinda crispy stuff"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 24)
    }
        
    func test_that_an_infinite_number_of_closing_brackets_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = "wow ok so that's!]]]]]]]]]]]]   kinda crispy stuff"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 32)
    }
    
    func test_that_a_closing_braces_are_NOT_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = "wow ok so that's!}}}}}}}}}}}}   kinda crispy stuff"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 49)
    }
    
    func test_that_an_infinite_number_of_doubleQuotes_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = #"wow ok so that's?"""   kinda crispy stuff"#
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 23)
    }

    func test_that_an_infinite_number_of_singleQuotes_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = #"wow ok so that's?''''''''   kinda crispy stuff"#
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 28)
    }
        
}


// TextViews
extension FT_beginningOfSentenceForward_Tests {
    
    func test_that_paragraph_boundaries_are_also_sentence_boundaries() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 62)
    }
       
    func test_that_it_does_not_get_stuck_in_the_middle_of_multiple_emptyLines() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 62)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 67)
    }
        
    func test_that_if_the_caret_is_on_an_emptyLine_and_the_text_ends_by_multiple_emptyLines_then_it_goes_to_the_end() {
        let text = """
plenty of empty lines
below







"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 29)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 34)
    }

}
