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
    
    func test_that_if_there_are_not_start_nor_end_match_then_it_returns_the_whole_text_lol() {
        let text = "dum b"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 5) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_the_end_of_the_first_sentence_not_including_the_trailing_blank() {
        let text = "dum b. and dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 6) 
    }
        
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_the_end_of_the_first_sentence_not_including_the_trailing_blanks() {
        let text = "dum b.                      and dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 6) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_does_not_stop_at_blanks_when_looking_backward_and_return_from_the_start_of_the_text_to_the_end_of_the_first_sentence_not_including_the_trailing_blanks() {
        let text = "dumb   and.     dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 11) 
    }
    
    func test_that_for_the_last_sentence_of_the_text_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_blanks_to_the_end_of_the_text() {
        let text = "dumb   and.     du mber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 7) 
    }
    
    func test_that_if_a_sentence_is_surrounded_by_two_other_sentences_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blanks_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = "dumb. a nd. dumber."
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 6)
        XCTAssertEqual(innerSentenceRange.count, 5) 
    }
    
    func test_that_we_actually_calculate_the_range_according_to_the_last_start_match_upperBound_and_not_lowerBound_lol() {
        let text = """
dumb. and." dum ber.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 15)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 12)
        XCTAssertEqual(innerSentenceRange.count, 8)
    }

    func test_that_if_the_caret_is_on_the_leading_blanks_of_a_sentence_it_just_returns_the_leading_blanks_of_that_sentence_lol() {
        let text = "dumb.        and.      dumber."
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 9)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 5)
        XCTAssertEqual(innerSentenceRange.count, 8) 
    }
        
    func test_that_if_the_caret_is_within_a_sentence_it_returns_from_the_beginning_of_that_sentence_not_including_leading_blanks_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = "dumb.        and  and.      dumber."
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 13)
        XCTAssertEqual(innerSentenceRange.count, 9) 
    }
    
    func test_that_if_the_caret_is_on_only_a_single_blank_that_is_before_a_sentence_it_just_returns_the_leading_blank_of_that_sentence_lol() {
        let text = "dumb. and dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 5)
        XCTAssertEqual(innerSentenceRange.count, 1) 
    }
    
    func test_that_if_the_caret_is_on_only_a_single_blank_that_is_at_the_end_of_the_text_then_returns_from_the_first_non_blank_before_that_blank_to_the_end_of_the_text() {
        let text = "dumb. and dumber "
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 1)
    }
    
    func test_that_if_the_caret_is_only_on_a_single_blank_that_is_within_the_last_sentence_of_the_text_then_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_blanks_to_the_end_of_the_last_sentence_not_including_the_trailing_blanks() {
        let text = "dumb. and dumber "
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 9)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 6)
        XCTAssertEqual(innerSentenceRange.count, 10)
    }
    
    func test_that_if_the_caret_is_only_on_a_single_blank_that_is_within_the_first_sentence_of_the_text_then_it_returns_from_the_beginning_of_the_first_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_not_including_the_trailing_blanks() {
        let text = "  and dumber.  dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 13)
    }
    
    func test_that_if_the_caret_is_only_on_a_single_blank_that_is_before_the_first_sentence_of_the_text_then_it_returns_from_the_beginning_of_the_first_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_not_including_the_trailing_blanks() {
        let text = "  and dumber.  dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 13)
    }

}


// TextViews
// basic
extension FT_innerSentence_NormalSetting_onBlank_Tests {
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_then_it_returns_from_the_beginning_of_that_sentence_to_the_end_of_that_sentence_not_including_the_leading_and_trailing_newlines() {
        let text = """
this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 24)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 14) 
    }
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_and_that_there_are_blanks_between_the_leading_newline_and_the_previous_dot_then_it_returns_from_the_beginning_of_that_sentence_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_that_sentence_not_including_the_trailing_newline() {
        let text = """
this is a line.  
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 26)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 18)
        XCTAssertEqual(innerSentenceRange.count, 14) 
    }
    
    func test_that_if_the_caret_is_on_the_last_sentence_of_the_text_that_is_separated_from_another_sentence_above_by_a_newline_then_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_newline_to_the_end_of_the_text() {
        let text = """
this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 42)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 31)
        XCTAssertEqual(innerSentenceRange.count, 16) 
    }
    
    func test_that_if_the_caret_is_on_the_last_sentence_of_the_text_that_is_separated_from_another_sentence_above_by_a_newline_and_that_there_are_blanks_between_that_newline_and_the_previous_dot_then_it_returns_from_the_beginning_of_the_last_sentence_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_the_text() {
        let text = """
this is a line.
then one more.  
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 36)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 33)
        XCTAssertEqual(innerSentenceRange.count, 16) 
    }
    
    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence() {
        let text = """
this is a line
then one more.
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 19)

        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 29)
    }

    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence_not_including_the_trailing_blanks() {
        let text = """
this is a line  
then one more.  
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 25)

        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 31)
    }
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_and_that_there_are_blanks_between_the_leading_newline_and_the_previous_dot_but_also_there_are_trailing_blanks_on_that_sentence_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = """
this is a line.  
then one more.  
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 22)

        XCTAssertEqual(innerSentenceRange.lowerBound, 18)
        XCTAssertEqual(innerSentenceRange.count, 14)
    }

    func test_basically_that_when_the_caret_is_on_the_leading_blanks_of_a_sentence_and_that_the_previous_non_blank_from_that_blank_is_a_newline_then_it_returns_the_range_of_leading_blanks() {
        let text = """
this is a line.
  then one more.
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)

        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 2)
    }

    func test_basically_that_when_the_caret_is_on_the_leading_blanks_of_a_sentence_and_that_the_previous_non_blank_from_that_blank_is_not_a_newline_then_it_returns_that_group_of_blanks_that_will_actually_include_a_newline_lol_fuck() {
        let text = """
this is a line.  
  then one more.
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 19)

        XCTAssertEqual(innerSentenceRange.lowerBound, 15)
        XCTAssertEqual(innerSentenceRange.count, 5)
    }
    
    func test_basically_that_when_the_caret_is_on_the_trailing_blanks_of_a_sentence_and_that_the_next_non_blank_from_that_blank_is_a_newline_then_it_returns_that_group_of_blanks_not_including_the_newline() {
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
    
    func test_that_if_the_caret_is_on_the_second_sentence_of_the_text_and_the_first_line_is_an_EmptyLine_then_it_returns_from_the_beginning_of_the_second_sentence_not_including_the_leading_newline_to_the_end_of_that_second_sentence_not_including_the_trailing_newline() {
        let text = """

this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 8)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 1)
        XCTAssertEqual(innerSentenceRange.count, 15) 
    }
    
    func test_basically_that_if_the_text_starts_with_a_whole_bunch_of_EmptyLines_it_still_returns_from_the_beginning_of_the_somehow_first_real_sentence_not_including_any_leading_newlines_to_the_end_of_that_sentence_not_including_the_trailing_newline() {
        let text = """



this is a line.
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 3)
        XCTAssertEqual(aSentenceRange.count, 15) 
    }
    
    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_paragraph_backward_boundary_to_the_end_of_the_current_sentence() {
        let text = """
first line hehe

above is an EL!
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 25)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 17)
        XCTAssertEqual(innerSentenceRange.count, 15)
    }
    
    func test_that_if_there_is_a_start_range_found_but_that_it_is_before_the_beginning_of_paragraph_backward_boundary_then_it_returns_from_the_beginning_of_paragraph_backward_boundary_to_the_end_of_the_current_sentence() {
        let text = """
first line hehe.



above is an EL!
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 25)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 20)
        XCTAssertEqual(innerSentenceRange.count, 15)
    }
   
}
    
    
// TextViews
// surrounded by BlankLines
extension FT_innerSentence_NormalSetting_onBlank_Tests {
    
    func test_that_if_there_is_no_start_range_found_then_it_does_not_stop_at_BlankLines_and_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence() {
        let text = """
first line hehe
       
above is an BL not an EL!
and BL are NOT sentence boundaries!
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 38)

        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 49)
    }

}
