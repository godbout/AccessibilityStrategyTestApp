@testable import AccessibilityStrategy
import XCTest


class FT_aSentence_OnBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_aSentence_OnBlankLines_Tests {

    func test_that_when_the_text_is_just_one_BlankLine_it_returns_from_the_beginning_of_the_text_to_the_current_caret_location() {
        let text = "                "
    
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 8)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 9) 
    }
    
}


// TextViews
// basic
extension FT_aSentence_OnBlankLines_Tests {
    
    func test_that_when_the_text_is_just_BlankLines_it_returns_from_the_beginning_of_the_text_to_the_current_caret_location() {
        let text = """
             
          
    
"""
    
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 19) 
    }
    
    func test_that_if_the_caret_is_on_the_first_BlankLine_the_text_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_first_sentence_with_characters_not_including_the_trailing_newline() {
        let text = """
      
this is a line.
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 22) 
    }
    
    func test_that_if_there_is_no_start_range_found_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_sentence_with_characters_that_is_below_the_BlankLine_including_the_trailing_blanks_of_that_line_but_not_the_trailing_newline() {
        let text = """
first line hehe
       
above is an BL not an EL!  
and BL are NOT sentence boundaries!
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)

        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 51)
    }
    
    func test_that_if_there_is_no_end_range_found_and_the_last_line_is_a_BlankLine_then_it_returns_a_range_from_the_last_NonBlank_character_included_to_the_single_next_Blank_character_included_which_is_really_weird() throws {
        let text = """
this is a line.
then one more.
and another one
        
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 52)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 45)
        XCTAssertEqual(aSentenceRange.count, 3) 
    }
    
}


// TextViews
// surrounded by BlankLines
extension FT_aSentence_OnBlankLines_Tests {
    
    func test_basically_that_if_the_text_starts_with_a_whole_bunch_of_BlankLines_it_still_returns_from_the_beginning_of_the_text_to_the_end_of_that_sentence_including_the_trailing_blanks_but_not_including_the_trailing_newline() {
        let text = """
  
 
   
this is a line.   
then one more.
and another one.
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 27) 
    }
    
    func test_that_if_there_is_a_start_range_found_but_that_it_is_before_a_bunch_of_BlankLines_then_it_returns_from_the_beginning_of_that_group_of_BlankLines_no_including_any_leading_newline_to_the_end_of_the_sentence_with_characters_that_below_the_group_of_BlankLines_not_including_the_trailing_blanks_of_that_sentence() {
        let text = """
first line hehe.
  
    
      
above is an EL!  
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 21)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 17)
        XCTAssertEqual(aSentenceRange.count, 30)
    }
    
    func test_that_if_there_is_no_end_range_found_and_the_last_lines_are_BlankLines_then_it_returns_a_range_from_the_last_NonBlank_character_included_to_the_single_next_Blank_character_included_which_is_really_weird() throws {
        let text = """
this is a line.
then one more.
and another one  
  
    
  
     
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 61)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 45)
        XCTAssertEqual(aSentenceRange.count, 2) 
    }
    
    func test_that_if_the_caret_is_on_the_first_line_that_is_a_BlankLine_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_sentence_with_characters_including_the_trailing_blanks_and_trailing_newlines_which_means_until_the_end_of_the_text_yes_wow() {
        let text = """
  
    this is.  
  
  
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 23) 
    }
    
}



// TODO: FR many more tests mixing EL and BL!!!
// TextViews
// surrounded by EmptyLines
extension FT_aSentence_OnBlankLines_Tests {
    
    func test_that_if_the_text_ends_with_BlankLines_and_that_before_them_there_is_an_EmptyLine_then_it_does_not_crash_LOL_and_returns_from_the_beginning_of_the_EmptyLine_to_the_first_Blank_of_the_next_line_included() {
        let text = """
this is a line.
then one more.
and another one  
  

  
     
"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 57)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 52)
        XCTAssertEqual(aSentenceRange.count, 2) 
    }

}
