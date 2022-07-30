@testable import AccessibilityStrategy
import XCTest


// tests for when the caret is not on an empty or blank line
class FT_beginningOfSentenceForward_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceForward(startingAt: caretLocation)
    }
    
}


// TextFields
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

// TODO: still need to check going forward towards emptyLines, and blankLines (behave differently)
