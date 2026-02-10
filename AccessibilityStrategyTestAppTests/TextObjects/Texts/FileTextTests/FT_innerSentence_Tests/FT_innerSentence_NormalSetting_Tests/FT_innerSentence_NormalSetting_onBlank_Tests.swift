@testable import AccessibilityStrategy
import XCTest


class FT_innerSentence_NormalSetting_onBlank_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_innerSentence_NormalSetting_onBlank_Tests {

    // TODO: remove the on a blank from the func names
    // TODO: match the Blank tests with nonBlank tests
    func test_that_if_the_caret_is_on_a_blank_that_is_before_a_sentence_it_just_returns_the_leading_blanks_of_that_sentence_lol() {
        let text = "dumb.        and.      dumber."
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 9)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 5)
        XCTAssertEqual(innerSentenceRange.count, 8) 
    }
        
    func test_that_if_the_caret_is_on_a_blank_within_a_sentence_it_returns_from_the_beginning_of_that_sentence_not_including_leading_blanks_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = "dumb.        and  and.      dumber."
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 13)
        XCTAssertEqual(innerSentenceRange.count, 9) 
    }
    
    func test_that_if_the_caret_is_on_a_single_blank_that_is_before_a_sentence_it_just_returns_the_leading_blank_of_that_sentence_lol() {
        let text = "dumb. and dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 5)
        XCTAssertEqual(innerSentenceRange.count, 1) 
    }
    
    func test_that_if_the_caret_is_on_a_single_blank_that_is_at_the_end_of_the_text_then_returns_from_the_first_non_blank_before_that_blank_to_the_end_of_the_text() {
        let text = "dumb. and dumber "
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 1)
    }
    
    func test_that_if_the_caret_is_on_a_single_blank_that_is_within_the_last_sentence_of_the_text_then_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_blanks_to_the_end_of_the_last_sentence_not_including_the_trailing_blanks() {
        let text = "dumb. and dumber "
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 9)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 6)
        XCTAssertEqual(innerSentenceRange.count, 10)
    }
    
    func test_that_if_the_caret_is_on_a_single_blank_that_is_within_the_first_sentence_of_the_text_then_it_returns_from_the_beginning_of_the_first_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_not_including_the_trailing_blanks() {
        let text = "  and dumber.  dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 13)
    }
    
    func test_that_if_the_caret_is_on_a_single_blank_that_is_before_the_first_sentence_of_the_text_then_it_returns_from_the_beginning_of_the_first_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_not_including_the_trailing_blanks() {
        let text = "  and dumber.  dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 13)
    }

}


// TextViews
// basic
extension FT_innerSentence_NormalSetting_onBlank_Tests {
    
    func test_basically_that_when_the_caret_is_on_a_blank_that_is_before_a_sentence_and_that_the_previous_non_blank_from_that_blank_is_a_newline_then_it_returns_the_range_of_leading_blanks() {
        let text = """
this is a line.
  then one more.
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)

        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 2)
    }

    func test_basically_that_when_the_caret_is_on_a_blank_that_is_before_a_sentence_and_that_the_previous_non_blank_from_that_blank_is_not_a_newline_then_it_returns_that_group_of_blanks_that_will_actually_include_a_newline_lol_fuck() {
        let text = """
this is a line.  
  then one more.
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 19)

        XCTAssertEqual(innerSentenceRange.lowerBound, 15)
        XCTAssertEqual(innerSentenceRange.count, 5)
    }
    
    func test_basically_that_when_the_caret_is_on_a_blank_that_is_after_a_sentence_and_that_the_next_non_blank_from_that_blank_is_a_newline_then_it_returns_that_group_of_blanks_not_including_the_newline() {
        let text = """
this is a line.
then one more.  
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 30)

        XCTAssertEqual(innerSentenceRange.lowerBound, 30)
        XCTAssertEqual(innerSentenceRange.count, 2)
    }

}


// TextViews
// surrounded by EmptyLines
extension FT_innerSentence_NormalSetting_onBlank_Tests {
   
}
    
    
// TextViews
// surrounded by BlankLines
extension FT_innerSentence_NormalSetting_onBlank_Tests {

}
