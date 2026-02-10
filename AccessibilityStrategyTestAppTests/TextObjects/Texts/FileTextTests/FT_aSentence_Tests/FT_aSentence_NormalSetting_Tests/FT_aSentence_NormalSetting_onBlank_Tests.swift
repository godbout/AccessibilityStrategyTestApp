@testable import AccessibilityStrategy
import XCTest


class FT_aSentence_NormalSetting_onBlank_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_aSentence_NormalSetting_onBlank_Tests {
    
    func test_that_if_the_caret_is_on_a_blank_that_is_right_after_a_dot_it_returns_the_correct_range_and_does_not_include_the_previous_sentence() {
        let text = "dumb. and. dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 5)
        XCTAssertEqual(aSentenceRange.count, 5) 
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
    
    func test_that_if_the_caret_is_on_a_single_blank_that_is_within_the_last_sentence_of_the_text_that_has_both_leading_and_trailing_blanks_then_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_blanks_to_the_end_of_the_last_sentence_including_the_trailing_blanks() {
        let text = "dumb.  and dumber   "
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 7)
        XCTAssertEqual(aSentenceRange.count, 13)
    }
    
    func test_that_if_the_caret_is_on_a_single_blank_that_within_the_first_sentence_of_the_text_that_has_both_leading_and_trailing_blanks_then_it_returns_from_the_beginning_of_the_first_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "  and dumber.  dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 15)
    }
    
    func test_that_if_the_caret_is_on_a_single_blank_that_is_before_the_first_sentence_of_the_text_that_has_both_leading_obviously_and_trailing_blanks_then_it_returns_from_the_beginning_of_the_first_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "  and dumber.  dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 15)
    }
    
}


// TextViews
// basic
extension FT_aSentence_NormalSetting_onBlank_Tests {
    
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

    func test_basically_that_when_the_caret_is_on_a_blank_that_is_before_a_sentence_and_that_the_previous_non_blank_from_that_blank_is_not_a_newline_then_it_returns_from_the_beginning_of_the_sentence_including_leading_blanks_that_will_actually_contain_a_newline_to_the_end_of_the_sentence_not_including_the_trailing_newline() {
        let text = """
this is a line.  
  then one more.
and another one.
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)

        XCTAssertEqual(aSentenceRange.lowerBound, 15)
        XCTAssertEqual(aSentenceRange.count, 19)
    }

    func test_basically_that_when_the_caret_is_on_a_blank_that_is_after_a_sentence_and_that_the_next_non_blank_from_that_blank_is_a_newline_then_it_returns_from_the_beginning_of_the_sentence_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = """
this is a line.
then one more.  
and another one.  
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 30)

        XCTAssertEqual(aSentenceRange.lowerBound, 30)
        XCTAssertEqual(aSentenceRange.count, 19)
    }

}


// TextViews
// surrounded by EmptyLines
extension FT_aSentence_NormalSetting_onBlank_Tests {
    
}


// TextViews
// surrounded by BlankLines
extension FT_aSentence_NormalSetting_onBlank_Tests {

}
