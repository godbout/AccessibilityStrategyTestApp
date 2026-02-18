@testable import AccessibilityStrategy
import XCTest


class FT_innerSentence_NormalSetting_onNonBlank_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_innerSentence_NormalSetting_onNonBlank_Tests {

    func test_that_if_the_text_is_just_one_word_then_it_returns_the_whole_text_lol() {
        let text = "dumb"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 4) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_the_end_of_the_first_sentence_not_including_the_trailing_blank() {
        let text = "dumb. and dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 5) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_the_end_of_the_first_sentence_not_including_the_trailing_blanks() {
        let text = "dumb.                      and dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 5) 
    }
        
    func test_that_for_the_first_sentence_of_the_text_it_does_not_stop_at_blanks_when_looking_backward_and_return_from_the_start_of_the_text_to_the_end_of_the_first_sentence_not_including_the_trailing_blanks() {
        let text = "dumb   and.     dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 8)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 11) 
    }
    
    func test_that_for_the_last_sentence_of_the_text_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_blanks_to_the_end_of_the_text() {
        let text = "dumb   and.     dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 6) 
    }
    
    func test_that_if_a_sentence_is_surrounded_by_two_other_sentences_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blanks_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = "dumb. and. dumber."
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 6)
        XCTAssertEqual(innerSentenceRange.count, 4) 
    }
    
    func test_that_we_actually_calculate_the_range_according_to_the_last_start_match_upperBound_and_not_lowerBound_lol() {
        let text = """
dumb. and." dumber.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 15)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 12)
        XCTAssertEqual(innerSentenceRange.count, 7)
    }
    
    func test_that_for_the_last_sentence_of_the_text_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_blanks_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = "dumb. and dumber "  
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 6)
        XCTAssertEqual(innerSentenceRange.count, 10)
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_not_including_the_trailing_blank() {
        let text = "   dumb. and dumber"  
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 8)
    }
    
    func test_that_if_there_are_no_start_range_found_and_no_end_range_found_then_it_returns_from_the_beginning_of_the_text_even_if_there_are_leading_blanks_to_the_last_NonBlank_included_of_the_text() {
        let text = "   dumb and dumber   "  
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 18)
    }
    
}


// TextViews
// basic
extension FT_innerSentence_NormalSetting_onNonBlank_Tests {
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_then_it_returns_from_the_beginning_of_that_sentence_to_the_end_of_that_sentence_not_including_the_leading_and_trailing_newlines() {
        let text = """
this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 26)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 14) 
    }
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_and_that_there_are_blanks_between_the_leading_newline_and_the_previous_dot_then_it_returns_from_the_beginning_of_that_sentence_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_that_sentence_not_including_the_trailing_newline() {
        let text = """
this is a line.  
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 27)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 18)
        XCTAssertEqual(innerSentenceRange.count, 14) 
    }
    
    func test_that_if_the_caret_is_on_the_last_sentence_of_the_text_that_is_separated_from_another_sentence_above_by_a_newline_then_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_newline_to_the_end_of_the_text() {
        let text = """
this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 41)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 31)
        XCTAssertEqual(innerSentenceRange.count, 16) 
    }
    
    func test_that_if_the_caret_is_on_the_last_sentence_of_the_text_that_is_separated_from_another_sentence_above_by_a_newline_and_that_there_are_blanks_between_that_newline_and_the_previous_dot_then_it_returns_from_the_beginning_of_the_last_sentence_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_the_text() {
        let text = """
this is a line.
then one more.  
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 41)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 33)
        XCTAssertEqual(innerSentenceRange.count, 16) 
    }
    
    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence() {
        let text = """
this is a line
then one more.
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 21)

        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 29)
    }

    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence_not_including_the_trailing_blanks() {
        let text = """
this is a line  
then one more.  
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 26)

        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 31)
    }
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_and_that_there_are_blanks_between_the_leading_newline_and_the_previous_dot_but_also_there_are_trailing_blanks_on_that_sentence_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = """
this is a line.  
then one more.  
and another one.
"""

        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 24)

        XCTAssertEqual(innerSentenceRange.lowerBound, 18)
        XCTAssertEqual(innerSentenceRange.count, 14)
    }
    
}


// TextViews
// surrounded by EmptyLines
extension FT_innerSentence_NormalSetting_onNonBlank_Tests {
    
    func test_that_if_the_caret_is_on_the_second_sentence_of_the_text_and_the_first_line_is_an_EmptyLine_then_it_returns_from_the_beginning_of_the_second_sentence_not_including_the_leading_newline_to_the_end_of_that_second_sentence_not_including_the_trailing_newline() {
        let text = """

this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 1)
        XCTAssertEqual(innerSentenceRange.count, 15) 
    }
    
    func test_basically_that_if_the_text_starts_with_a_whole_bunch_of_EmptyLines_it_still_returns_from_the_beginning_of_the_somehow_first_real_sentence_not_including_any_leading_newlines_to_the_end_of_that_sentence_not_including_trailing_blanks_nor_the_trailing_newline() {
        let text = """



this is a line.  
then one more.
and another one.
"""
        
        let innerSentence = applyFuncBeingTested(on: text, startingAt: 9)
        
        XCTAssertEqual(innerSentence.lowerBound, 3)
        XCTAssertEqual(innerSentence.count, 15) 
    }
    
    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_paragraph_backward_boundary_to_the_end_of_the_current_sentence() {
        let text = """
first line hehe

above is an EL!
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 26)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 17)
        XCTAssertEqual(innerSentenceRange.count, 15)
    }
    
    func test_that_if_there_is_a_start_range_found_but_that_it_is_before_the_beginning_of_paragraph_backward_boundary_then_it_returns_from_the_beginning_of_paragraph_backward_boundary_to_the_end_of_the_current_sentence_not_including_the_trailing_blanks_nor_the_trailing_newline() {
        let text = """
first line hehe.



above is an EL!  
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 26)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 20)
        XCTAssertEqual(innerSentenceRange.count, 15)
    }
    
    func test_that_if_there_is_no_end_range_found_then_it_returns_from_the_beginning_of_the_current_sentence_to_the_paragraph_forward_boundary_but_also_not_including_the_leading_newline_wor() {
        let text = """
this is a line.
then one more.
and another one

"""
        
        let innerSentence = applyFuncBeingTested(on: text, startingAt: 40)
        
        XCTAssertEqual(innerSentence.lowerBound, 31)
        XCTAssertEqual(innerSentence.count, 15) 
    }
    
    func test_basically_that_if_the_text_ends_with_a_whole_bunch_of_EmptyLines_it_still_returns_from_the_beginning_of_the_current_sentence_to_the_paragraph_forward_boundary_but_also_not_including_the_newline() {
        let text = """
this is a line.
then one more.
and another one




"""
        
        let innerSentence = applyFuncBeingTested(on: text, startingAt: 40)
        
        XCTAssertEqual(innerSentence.lowerBound, 31)
        XCTAssertEqual(innerSentence.count, 15) 
    }
    
    func test_that_if_there_is_no_end_range_found_then_it_returns_from_the_beginning_of_the_current_sentence_to_the_end_of_the_current_sentence_not_including_the_trailing_blanks_nor_the_trailing_newline() {
        let text = """
this is a line.
then one more.
and another one  

"""
        
        let innerSentence = applyFuncBeingTested(on: text, startingAt: 40)
        
        XCTAssertEqual(innerSentence.lowerBound, 31)
        XCTAssertEqual(innerSentence.count, 15) 
    }
    
}
    
    
// TextViews
// surrounded by BlankLines
extension FT_innerSentence_NormalSetting_onNonBlank_Tests {

    func test_that_if_the_caret_is_on_the_second_sentence_of_the_text_and_the_first_line_is_a_BlankLine_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_that_second_sentence_not_including_the_trailing_newline() {
        let text = """
      
this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 9)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 22) 
    }
    
    func test_basically_that_if_the_text_starts_with_a_whole_bunch_of_BlankLines_it_still_returns_from_the_beginning_of_the_text_to_the_end_of_that_sentence_not_including_trailing_blanks_nor_the_trailing_newline() {
        let text = """
  
    
      
this is a line.  
then one more.
and another one.
"""
        
        let innerSentence = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(innerSentence.lowerBound, 0)
        XCTAssertEqual(innerSentence.count, 30) 
    }
    
    func test_that_if_there_is_no_start_range_found_and_no_paragraph_backward_boundary_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence() {
        let text = """
first line hehe
   
above is an EL!
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 21)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 35)
    }
    
    func test_that_if_there_is_no_end_range_found_then_it_returns_from_the_beginning_of_the_current_sentence_to_the_end_of_the_current_sentence_not_including_the_trailing_blanks_nor_the_trailing_newline_nor_the_following_BlankLine() {
        let text = """
this is a line.
then one more.
and another one
  
"""
        
        let innerSentence = applyFuncBeingTested(on: text, startingAt: 40)
        
        XCTAssertEqual(innerSentence.lowerBound, 31)
        XCTAssertEqual(innerSentence.count, 15) 
    }
    
}
