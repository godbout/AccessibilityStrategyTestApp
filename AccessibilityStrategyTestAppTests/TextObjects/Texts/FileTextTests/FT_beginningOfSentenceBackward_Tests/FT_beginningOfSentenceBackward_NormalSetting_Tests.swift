@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfSentenceBackward_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceBackward(startingAt: caretLocation)
    }
    
}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_beginningOfSentenceBackward_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_on_the_last_EmptyLine_it_still_works() {
        let text = """
that this is gonna
go up

"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 25)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
}


// both
extension FT_beginningOfSentenceBackward_Tests {

    func test_that_if_the_text_is_just_one_word_then_it_goes_to_the_beginning_of_the_text() {
        let text = "dumb"
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_it_detects_the_dot_as_an_end_of_sentence() {
        let text = "very dumb. and dumber"
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 12)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 11)
    }
    
    func test_that_it_works_even_with_multiple_spaces() {
        let text = "dumb. and.                      dumber"
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 36)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 32)
    }
    
    func test_that_it_detects_the_exclamation_mark_as_an_end_of_sentence() {
        let text = "dumb. and!    dumber"
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 14)
    }
        
    func test_that_it_detects_the_interrogation_mark_as_an_end_of_sentence() {
        let text = "dumb. and dumber?  is that true"
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 27)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 19)
    }
        
    func test_that_it_requires_at_least_one_space_after_the_delimiting_punctuation() {
        let text = "dumb.anddumber?is  that true"
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 25)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
        
    func test_that_an_infinite_number_of_closing_parentheses_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = "wow ok so that's.))))   kinda crispy stuff"
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 38)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 24)
    }
        
    func test_that_an_infinite_number_of_closing_brackets_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = "wow ok so that's!]]]]]]]]]]]]   kinda crispy stuff"
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 42)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 32)
    }
    
    func test_that_a_closing_braces_are_NOT_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = "wow ok so that's!}}}}}}}}}}}}   kinda crispy stuff"
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 42)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_an_infinite_number_of_doubleQuotes_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = #"wow ok so that's?"""   kinda crispy stuff"#
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 37)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 23)
    }

    func test_that_an_infinite_number_of_singleQuotes_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = #"wow ok so that's?''''''''   kinda crispy stuff"#
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 39)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 28)
    }
        
}


// TextViews
extension FT_beginningOfSentenceBackward_Tests {
    
    // TODO: this one
    // TODO: plus stuck when already at the beginning of sentence
    func test_that_paragraph_boundaries_are_also_sentence_boundaries() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 84)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 62)
    }
    
}
