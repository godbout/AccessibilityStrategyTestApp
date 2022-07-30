@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfSentenceBackward_NormalSetting_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceBackward(startingAt: caretLocation)
    }
    
}


// both
extension FT_beginningOfSentenceBackward_NormalSetting_Tests {

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
    
    func test_that_if_it_is_already_at_the_beginning_of_the_current_sentence_then_it_does_not_get_stuck_and_goes_to_the_beginning_of_the_previous_sentence() {
        let text = "one more to start. now we gonna have. two sentenced and current it gets stuck"
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 38)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 19)
    }
    
    func test_that_it_skips_consecutive_blanks_because_there_is_a_bug() {
        let text = "one more.    ok so it seems that.       if there are many blanks it does not work"
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 38)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 13)
        
    }
        
}


// TextViews
extension FT_beginningOfSentenceBackward_NormalSetting_Tests {
    
    func test_that_paragraph_boundaries_are_also_sentence_boundaries() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 84)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 67)
    }
    
    func test_that_it_does_not_stop_at_consecutive_lines_when_the_lines_start_with_blanks() {
        let text = """
this is a first line

   for example it
   it should go to the empty line
   no the lines above
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 87)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 25)
    }
    
    func test_that_it_stops_at_the_emptyLine_right_above_even_when_there_are_multiple_consecutive_lines() {
        let text = """
  it shoud




  go up directly
""" 
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 14)
    }
    
    func test_that_it_stops_at_the_emptyLine_right_above_even_if_there_is_only_one() {
        let text = """
it should

stop on the empty line above
""" 
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 11)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 10)
    }
    
}
