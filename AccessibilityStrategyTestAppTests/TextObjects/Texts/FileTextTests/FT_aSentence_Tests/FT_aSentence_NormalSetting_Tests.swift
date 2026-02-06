@testable import AccessibilityStrategy
import XCTest


class FT_aSentence_NormalSetting_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_aSentence_NormalSetting_Tests {

    func test_that_if_the_text_is_just_one_word_then_it_returns_the_whole_text_lol() {
        let text = "dumb"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 4) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_the_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "dumb. and dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 6) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "dumb.                      and dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 27) 
    }
        
    func test_that_for_the_first_sentence_of_the_text_it_does_not_stop_at_blanks_when_looking_backward_and_return_from_the_start_of_the_text_to_the_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "dumb   and.     dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 8)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 16) 
    }
    
    func test_that_for_the_last_sentence_of_the_text_it_returns_from_the_beginning_of_the_last_sentence_including_the_leading_blanks_to_the_end_of_the_text() {
        let text = "dumb   and.     dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 11)
        XCTAssertEqual(aSentenceRange.count, 11) 
    }
    
    func test_that_if_a_sentence_is_surrounded_by_two_other_sentences_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blank_to_the_end_of_the_sentence_including_the_trailing_blank() {
        let text = "dumb. and. dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 6)
        XCTAssertEqual(aSentenceRange.count, 5) 
    }
    
    func test_that_if_the_caret_is_on_a_blank_that_is_right_after_a_dot_it_returns_the_correct_range_and_does_not_include_the_previous_sentence() {
        let text = "dumb. and. dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 5)
        XCTAssertEqual(aSentenceRange.count, 5) 
    }
    
    func test_that_if_a_sentence_is_surrounded_by_two_other_sentences_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blanks_to_the_end_of_the_sentence_including_the_trailing_blanks() {
        let text = "dumb.        and.      dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 14)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 13)
        XCTAssertEqual(aSentenceRange.count, 10) 
    }
    
    
    func test_that_if_the_caret_is_on_a_blank_that_is_before_a_sentence_it_returns_from_the_beginning_of_that_sentence_including_the_leading_blanks_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = "dumb.        and.      dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 9)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 5)
        XCTAssertEqual(aSentenceRange.count, 12) 
    }
    
    func test_that_if_the_caret_is_on_a_blank_within_a_sentence_it_returns_from_the_beginning_of_that_sentence_not_including_leading_blanks_to_the_end_of_that_sentence_including_trailing_blanks() {
        let text = "dumb.        and  and.      dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 13)
        XCTAssertEqual(aSentenceRange.count, 15) 
    }
    
    func test_that_when_calculating_the_start_of_the_range_it_returns_from_the_last_match_and_not_from_the_first_match() {
        let text = "dumb.        and  and.      dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 31)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 22)
        XCTAssertEqual(aSentenceRange.count, 13) 
    }
    
    func test_that_if_the_caret_is_on_a_single_blank_that_is_within_the_last_sentence_of_the_text_that_has_both_leading_and_trailing_blanks_then_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_blanks_to_the_end_of_the_last_sentence_including_the_trailing_blanks() {
        let text = "dumb.  and dumber   "
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 7)
        XCTAssertEqual(innerSentenceRange.count, 13)
    }
    
    func test_that_if_the_caret_is_on_a_single_blank_that_within_the_first_sentence_of_the_text_that_has_both_leading_and_trailing_blanks_then_it_returns_from_the_beginning_of_the_first_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "  and dumber.  dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 15)
    }
    
    func test_that_if_the_caret_is_on_a_single_blank_that_is_before_the_first_sentence_of_the_text_that_has_both_leading_obviously_and_trailing_blanks_then_it_returns_from_the_beginning_of_the_first_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "  and dumber.  dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 15)
    }
    
    // TODO: add some more?
    
}


// TextViews
// basic
extension FT_aSentence_NormalSetting_Tests {
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_then_it_returns_from_the_beginning_of_that_sentence_to_the_end_of_that_sentence_not_including_the_leading_and_trailing_newlines() {
        let text = """
this is a line.
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 26)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 16)
        XCTAssertEqual(aSentenceRange.count, 14) 
    }
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_and_that_there_are_blanks_between_the_leading_newline_and_the_previous_dot_then_it_returns_from_the_beginning_of_that_sentence_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_that_sentence_not_including_the_trailing_newline() {
        let text = """
this is a line.  
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 27)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 15)
        XCTAssertEqual(aSentenceRange.count, 17) 
    }
    
    func test_that_if_the_caret_is_on_the_last_sentence_of_the_text_that_is_separated_from_another_sentence_above_by_a_newline_then_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_newline_to_the_end_of_the_text() {
        let text = """
this is a line.
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 41)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 31)
        XCTAssertEqual(aSentenceRange.count, 16) 
    }
    
    func test_that_if_the_caret_is_on_the_last_sentence_of_the_text_that_is_separated_from_another_sentence_above_by_a_newline_and_that_there_are_blanks_between_that_newline_and_the_previous_dot_then_it_returns_from_the_beginning_of_the_last_sentence_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_the_text() {
        let text = """
this is a line.
then one more.  
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 41)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 30)
        XCTAssertEqual(aSentenceRange.count, 19) 
    }
    
    func test_basically_that_when_the_caret_is_on_a_blank_that_is_before_a_sentence_and_that_the_previous_non_blank_from_that_blank_is_a_newline_then_it_returns_from_the_beginning_of_the_sentence_including_the_leading_blanks_to_the_end_of_the_sentence_not_including_the_trailing_newline() {
        let text = """
this is a line.
  then one more.
and another one.
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)

        XCTAssertEqual(aSentenceRange.lowerBound, 16)
        XCTAssertEqual(aSentenceRange.count, 16)
    }

}


// TextViews
// surrounded by EmptyLines
extension FT_aSentence_NormalSetting_Tests {
    
    func test_that_if_the_caret_is_on_the_second_sentence_of_the_text_and_the_first_line_is_an_EmptyLine_then_it_returns_from_the_beginning_of_the_second_sentence_not_including_the_leading_newline_to_the_end_of_that_second_sentence_not_including_the_trailing_newline() {
        let text = """

this is a line.
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 1)
        XCTAssertEqual(aSentenceRange.count, 15) 
    }
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_and_that_there_are_blanks_between_the_leading_newline_and_the_previous_dot_but_also_there_are_trailing_blanks_on_that_sentence_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_that_sentence_including_the_trailing_blanks() {
        let text = """
this is a line.  
then one more.  
and another one.
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 24)

        XCTAssertEqual(aSentenceRange.lowerBound, 18)
        XCTAssertEqual(aSentenceRange.count, 16)
    }

    // TODO: need to add multiple EL in a row. gonna be painful...

}
