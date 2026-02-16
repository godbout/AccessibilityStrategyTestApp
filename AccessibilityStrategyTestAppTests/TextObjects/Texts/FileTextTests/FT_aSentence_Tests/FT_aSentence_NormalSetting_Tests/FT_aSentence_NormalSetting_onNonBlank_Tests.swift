@testable import AccessibilityStrategy
import XCTest


class FT_aSentence_NormalSetting_onNonBlank_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aSentence(startingAt: caretLocation)
    }
    
}


// TODO: add some more?
// how tho? aren't they all done? i think need to try with
// `vis` and `vas` to see if some cases are fucked
// TextFields and TextViews
extension FT_aSentence_NormalSetting_onNonBlank_Tests {

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
    
    func test_that_if_a_sentence_is_surrounded_by_two_other_sentences_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blanks_to_the_end_of_the_sentence_including_the_trailing_blanks() {
        let text = "dumb.        and.      dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 14)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 13)
        XCTAssertEqual(aSentenceRange.count, 10) 
    }
    
    func test_that_when_calculating_the_start_of_the_range_it_returns_from_the_last_match_and_not_from_the_first_match() {
        let text = "dumb.        and  and.      dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 31)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 22)
        XCTAssertEqual(aSentenceRange.count, 13) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_including_the_trailing_blank() {
        let text = "   dumb. and dumber"  
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 9)
    }

}


// TextViews
// basic
extension FT_aSentence_NormalSetting_onNonBlank_Tests {
    
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
    
    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence() {
        let text = """
this is a line
then one more.
and another one.
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 21)

        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 29)
    }

    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence_including_the_trailing_blanks_and_not_including_the_trailing_newline() {
        let text = """
this is a line  
then one more.  
and another one.
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 26)

        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 33)
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
    
}


// TODO: isn't it the last ones to add are for endOfParagraph boundary?
// with no endMatch, boundaries between paragraphs, etc.
// TextViews
// surrounded by EmptyLines
extension FT_aSentence_NormalSetting_onNonBlank_Tests {
    
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
    
    func test_basically_that_if_the_text_starts_with_a_whole_bunch_of_EmptyLines_it_still_returns_from_the_beginning_of_the_somehow_first_real_sentence_not_including_any_leading_newlines_to_the_end_of_that_sentence_including_the_trailing_blanks_but_not_including_the_trailing_newline() {
        let text = """



this is a line.   
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 9)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 3)
        XCTAssertEqual(aSentenceRange.count, 18) 
    }
    
    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_paragraph_backward_boundary_to_the_end_of_the_current_sentence() {
        let text = """
first line hehe

above is an EL!
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 26)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 17)
        XCTAssertEqual(aSentenceRange.count, 15)
    }
    
    func test_that_if_there_is_a_start_range_found_but_that_it_is_before_the_beginning_of_paragraph_backward_boundary_then_it_returns_from_the_beginning_of_paragraph_backward_boundary_to_the_end_of_the_current_sentence_including_the_trailing_blanks_but_not_including_the_trailing_newline() {
        let text = """
first line hehe.



above is an EL!   
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 26)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 20)
        XCTAssertEqual(innerSentenceRange.count, 18)
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
    
    func test_that_if_there_is_no_end_range_found_then_it_returns_from_the_beginning_of_the_current_sentence_to_the_end_of_the_current_sentence_including_the_trailing_blanks_but_not_the_trailing_newline() {
        let text = """
this is a line.
then one more.
and another one  

"""
        
        let innerSentence = applyFuncBeingTested(on: text, startingAt: 40)
        
        XCTAssertEqual(innerSentence.lowerBound, 31)
        XCTAssertEqual(innerSentence.count, 17) 
    }
    
}


// TODO: need to add cases here. same as EL above? need to think
// TextViews
// surrounded by BlankLines
extension FT_aSentence_NormalSetting_onNonBlank_Tests {

    func test_that_if_there_is_no_start_range_found_then_it_does_not_stop_at_BlankLines_and_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence_including_the_trailing_blanks_but_not_the_trailing_newline() {
        let text = """
first line hehe
       
above is an BL not an EL!  
and BL are NOT sentence boundaries!
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 39)

        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 51)
    }

}
