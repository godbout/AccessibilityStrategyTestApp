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
    
    func test_that_if_there_are_not_start_nor_end_match_then_it_returns_the_whole_text_lol() {
        let text = "dum b"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 5) 
    }
        
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_the_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "dum b. and dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 7) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "dum b.                      and dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 28) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_does_not_stop_at_blanks_when_looking_backward_and_return_from_the_start_of_the_text_to_the_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "dumb   a nd.     dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 8)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 17) 
    }
    
    func test_that_for_the_last_sentence_of_the_text_it_returns_from_the_beginning_of_the_last_sentence_including_the_leading_blanks_to_the_end_of_the_text() {
        let text = "dumb   and.     du mber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 11)
        XCTAssertEqual(aSentenceRange.count, 12) 
    }
    
    func test_that_if_a_sentence_is_surrounded_by_two_other_sentences_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blank_to_the_end_of_the_sentence_including_the_trailing_blank() {
        let text = "dumb. a nd. dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 6)
        XCTAssertEqual(aSentenceRange.count, 6) 
    }
    
    func test_that_if_a_sentence_is_surrounded_by_two_other_sentences_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blanks_to_the_end_of_the_sentence_including_the_trailing_blanks() {
        let text = "dumb.        a nd.      dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 14)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 13)
        XCTAssertEqual(aSentenceRange.count, 11) 
    }
    
    func test_that_when_calculating_the_start_of_the_range_it_returns_from_the_last_match_and_not_from_the_first_match() {
        let text = "dumb.        and  and.      dum ber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 31)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 22)
        XCTAssertEqual(aSentenceRange.count, 14) 
    }
    
    func test_that_if_the_caret_is_only_on_a_single_blank_that_is_right_after_a_dot_it_returns_the_correct_range_and_does_not_include_the_previous_sentence() {
        let text = "dumb. and. dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 5)
        XCTAssertEqual(aSentenceRange.count, 5) 
    }
    
    func test_that_if_the_caret_is_on_leading_blanks_of_a_sentence_it_returns_from_the_beginning_of_that_sentence_including_the_leading_blanks_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = "dumb.        and.      dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 9)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 5)
        XCTAssertEqual(aSentenceRange.count, 12) 
    }
    
    func test_that_if_the_caret_is_within_a_sentence_it_returns_from_the_beginning_of_that_sentence_not_including_leading_blanks_to_the_end_of_that_sentence_including_trailing_blanks() {
        let text = "dumb.        and  and.      dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 13)
        XCTAssertEqual(aSentenceRange.count, 15) 
    }
    
    func test_that_if_the_caret_is_only_on_a_single_blank_that_is_within_the_last_sentence_of_the_text_that_has_both_leading_and_trailing_blanks_then_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_blanks_to_the_end_of_the_last_sentence_including_the_trailing_blanks() {
        let text = "dumb.  and dumber   "
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 7)
        XCTAssertEqual(aSentenceRange.count, 13)
    }
    
    func test_that_if_the_caret_is_only_on_a_single_blank_that_within_the_first_sentence_of_the_text_that_has_both_leading_and_trailing_blanks_then_it_returns_from_the_beginning_of_the_first_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "  and dumber.  dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 15)
    }
    
    func test_that_if_the_caret_is_only_on_a_single_blank_that_is_before_the_first_sentence_of_the_text_that_has_both_leading_obviously_and_trailing_blanks_then_it_returns_from_the_beginning_of_the_first_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_including_the_trailing_blanks() {
        let text = "  and dumber.  dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 15)
    }
    
    func test_that_if_the_caret_is_within_the_first_sentence_of_the_text_it_returns_from_the_start_of_sentence_including_the_leading_blanks_to_the_end_of_the_first_sentence_including_the_trailing_blank() {
        let text = "   dum b. and dumber"  
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 10)
    }
    func test_that_if_the_caret_is_not_on_a_blank_that_is_at_the_end_of_the_text_but_within_a_sentence_and_that_there_are_no_start_range_found_and_no_end_range_found_then_it_returns_from_the_beginning_of_the_text_even_if_there_are_leading_blanks_to_the_end_of_the_text_even_if_there_are_trailing_blanks() {
        let text = "   dumb and dumber   "  
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 21)
    }
    
    // TODO: implement one day?
    // this move in Vim is weird. if `as` at the end of text on blanks it grab the last non blank character + 1?
    // honestly i don't think users will notice. it's just too weird even in Vim lol
    func test_that_if_the_caret_is_on_a_blank_that_is_at_the_end_of_the_text_and_that_there_are_no_start_range_found_and_no_end_range_found_then_it_returns_a_range_from_the_last_NonBlank_character_included_to_the_single_next_Blank_character_included_which_is_really_weird() throws {
        throw XCTSkip("edge case not handled yet coz it's super weird lol")
        
        let text = "   dumb and dumber   "  
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 19)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 17)
        XCTAssertEqual(innerSentenceRange.count, 2)
    }
    
}


// TextViews
// basic
extension FT_aSentence_NormalSetting_onBlank_Tests {
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_then_it_returns_from_the_beginning_of_that_sentence_to_the_end_of_that_sentence_not_including_the_leading_and_trailing_newlines() {
        let text = """
this is a line.
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 24)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 16)
        XCTAssertEqual(aSentenceRange.count, 14) 
    }
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_and_that_there_are_blanks_between_the_leading_newline_and_the_previous_dot_then_it_returns_from_the_beginning_of_that_sentence_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_that_sentence_not_including_the_trailing_newline() {
        let text = """
this is a line.  
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 26)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 15)
        XCTAssertEqual(aSentenceRange.count, 17) 
    }
    
    func test_that_if_the_caret_is_on_the_last_sentence_of_the_text_that_is_separated_from_another_sentence_above_by_a_newline_then_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_newline_to_the_end_of_the_text() {
        let text = """
this is a line.
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 42)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 31)
        XCTAssertEqual(aSentenceRange.count, 16) 
    }
    
    func test_that_if_the_caret_is_on_the_last_sentence_of_the_text_that_is_separated_from_another_sentence_above_by_a_newline_and_that_there_are_blanks_between_that_newline_and_the_previous_dot_then_it_returns_from_the_beginning_of_the_last_sentence_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_the_text() {
        let text = """
this is a line.
then one more.  
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 44)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 30)
        XCTAssertEqual(aSentenceRange.count, 19) 
    }
    
    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence() {
        let text = """
this is a line
then one more.
and another one.
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 19)

        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 29)
    }

    func test_that_if_there_is_no_start_range_found_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence_including_the_trailing_blanks_and_not_including_the_trailing_newline() {
        let text = """
this is a line  
then one more.  
and another one.
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 24)

        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 33)
    }
    
    func test_that_if_the_caret_is_on_a_sentence_separated_by_newlines_and_that_there_are_blanks_between_the_leading_newline_and_the_previous_dot_but_also_there_are_trailing_blanks_on_that_sentence_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_that_sentence_including_the_trailing_blanks() {
        let text = """
this is a line.  
then one more.  
and another one.
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 22)

        XCTAssertEqual(aSentenceRange.lowerBound, 18)
        XCTAssertEqual(aSentenceRange.count, 16)
    }
    
    func test_basically_that_when_the_caret_is_on_leading_blanks_of_a_sentence_and_that_the_previous_non_blank_from_that_blank_is_a_newline_then_it_returns_from_the_beginning_of_the_sentence_including_the_leading_blanks_to_the_end_of_the_sentence_not_including_the_trailing_newline() {
        let text = """
this is a line.
  then one more.
and another one.
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)

        XCTAssertEqual(aSentenceRange.lowerBound, 16)
        XCTAssertEqual(aSentenceRange.count, 16)
    }

    func test_basically_that_when_the_caret_is_on_leading_blanks_of_a_sentence_and_that_the_previous_non_blank_from_that_blank_is_not_a_newline_then_it_returns_from_the_beginning_of_the_sentence_including_leading_blanks_that_will_actually_contain_a_newline_to_the_end_of_the_sentence_not_including_the_trailing_newline() {
        let text = """
this is a line.  
  then one more.
and another one.
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)

        XCTAssertEqual(aSentenceRange.lowerBound, 15)
        XCTAssertEqual(aSentenceRange.count, 19)
    }

    func test_basically_that_when_the_caret_is_on_trailing_blanks_of_a_sentence_and_that_the_next_non_blank_from_that_blank_is_a_newline_then_it_returns_from_the_beginning_of_the_sentence_including_the_leading_blanks_and_the_leading_newline_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
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
    
    func test_that_if_the_caret_is_on_the_second_sentence_of_the_text_and_the_first_line_is_an_EmptyLine_then_it_returns_from_the_beginning_of_the_second_sentence_not_including_the_leading_newline_to_the_end_of_that_second_sentence_not_including_the_trailing_newline() {
        let text = """

this is a line.
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 1)
        XCTAssertEqual(aSentenceRange.count, 15) 
    }
    
    func test_basically_that_if_the_text_starts_with_a_whole_bunch_of_EmptyLines_it_still_returns_from_the_beginning_of_the_somehow_first_real_sentence_not_including_any_leading_newlines_to_the_end_of_that_sentence_including_the_trailing_blanks_but_not_including_the_trailing_newline() {
        let text = """



this is a line.   
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 10)
        
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
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 25)
        
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
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 25)
        
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
        
        let innerSentence = applyFuncBeingTested(on: text, startingAt: 42)
        
        XCTAssertEqual(innerSentence.lowerBound, 31)
        XCTAssertEqual(innerSentence.count, 17) 
    }
    
    // TODO: this move in Vim is weird. if `as` at the end of text on blanks it grab the last non blank character + 1?
    // actually the above is only true if there are no more than 2 EL after LMAO. if more then the selection is something different,
    // including the trailing blanks and some EL!!! crazy. not sure what to do yet.
//    func test_that_if_the_caret_is_on_trailing_blanks_and_there_is_no_start_range_found_nor_end_range_found_then_it_returns_a_range_from_the_last_NonBlank_character_included_to_the_single_next_Blank_character_included_which_is_really_weird() {
//        let text = """
//no start no end range and trailing blanks    
//
//
//"""
//        
//        let innerSentence = applyFuncBeingTested(on: text, startingAt: 42)
//        
//        XCTAssertEqual(innerSentence.lowerBound, 40)
//        XCTAssertEqual(innerSentence.count, 2) 
//    }
    
    func test_that_if_the_caret_is_on_leading_blanks_and_that_there_is_a_start_range_that_is_an_EmptyLine_then_actually_rather_than_returning_the_group_of_blanks_it_returns_from_the_beginning_of_the_sentence_with_character_not_including_those_leading_blanks_to_the_end_of_the_sentence_with_character_including_the_trailing_blanks_and_not_including_the_trailing_newlines_this_is_a_weird_edge_case_YES() {
        let text = """

    this is.  


"""
        
        let innerSentence = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(innerSentence.lowerBound, 5)
        XCTAssertEqual(innerSentence.count, 10) 
    }
    
}


// TextViews
// surrounded by BlankLines
extension FT_aSentence_NormalSetting_onBlank_Tests {
    
    func test_that_if_the_caret_is_on_the_second_sentence_of_the_text_and_the_first_line_is_a_BlankLine_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_that_second_sentence_not_including_the_trailing_newline() {
        let text = """
      
this is a line.
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 11)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 22) 
    }
    
    func test_basically_that_if_the_text_starts_with_a_whole_bunch_of_BlankLines_it_still_returns_from_the_beginning_of_the_text_to_the_end_of_that_sentence_including_the_trailing_blanks_but_not_including_the_trailing_newline() {
        let text = """
  
 
   
this is a line.   
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 13)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 27) 
    }
    
    func test_that_if_there_is_no_start_range_found_then_it_does_not_stop_at_BlankLines_and_returns_from_the_beginning_of_the_text_to_the_end_of_the_current_sentence_including_the_trailing_blanks_but_not_the_trailing_newline() {
        let text = """
first line hehe
       
above is an BL not an EL!  
and BL are NOT sentence boundaries!
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 38)

        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 51)
    }
    
    func test_that_if_there_is_a_start_range_found_but_that_it_is_before_a_bunch_of_BlankLines_then_it_returns_from_the_beginning_of_the_current_sentence_no_including_any_leading_newline_and_blanks_to_the_end_of_the_current_sentence_including_the_trailing_blanks_but_not_the_trailing_newline() {
        let text = """
first line hehe.
  
  
  
above is an EL!   bl
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 31)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 26)
        XCTAssertEqual(innerSentenceRange.count, 18)
    }

}
