@testable import AccessibilityStrategy
import XCTest


class FT_innerSentence_OnBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_innerSentence_OnBlankLines_Tests {

    func test_that_when_the_text_is_just_one_BlankLine_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_text() {
        let text = "                "
    
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 8)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 16) 
    }
    
}


// TextViews
// basic
extension FT_innerSentence_OnBlankLines_Tests {
    
    func test_that_if_the_caret_is_on_the_first_BlankLine_the_text_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_first_sentence_with_characters_not_including_the_trailing_newline() {
        let text = """
      
this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 22) 
    }
    
    func test_that_if_there_is_no_start_range_found_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_sentence_with_characters_that_is_below_the_BlankLine() {
        let text = """
first line hehe
   
above is an EL!
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 35)
    }
    
    func test_that_if_there_is_no_end_range_found_then_it_returns_from_the_beginning_of_that_group_of_BlankLines_to_the_end_of_that_group_of_BlankLines() {
        let text = """
this is a line.
then one more.
and another one
      
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 49)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 47)
        XCTAssertEqual(innerSentenceRange.count, 6) 
    }
    
    func test_that_if_there_is_no_end_range_found_and_the_last_line_is_a_BlankLine_then_it_returns_from_the_beginning_of_that_BlankLine_including_the_trailing_blanks_of_the_last_sentence_with_characters_to_the_end_of_that_BlankLine() {
        let text = """
this is a line.
then one more.
and another one  
  
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 50)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 46)
        XCTAssertEqual(innerSentenceRange.count, 5) 
    }
    
}


// TextViews
// surrounded by BlankLines
extension FT_innerSentence_OnBlankLines_Tests {
    
    func test_basically_that_if_the_text_starts_with_a_whole_bunch_of_BlankLines_it_still_returns_from_the_beginning_of_the_text_to_the_end_of_first_sentence_with_characters_not_including_trailing_blanks_nor_the_trailing_newline() {
        let text = """
  
    
      
this is a line.  
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 30) 
    }
    
    func test_that_if_there_is_a_start_range_found_but_that_it_is_before_a_bunch_of_BlankLines_then_it_returns_from_the_beginning_of_that_group_of_BlankLines_to_the_end_of_that_group_of_BlankLines_not_including_the_trailing_newline() {
        let text = """
first line hehe.
  
    
      
above is an EL!  
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 21)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 17)
        XCTAssertEqual(innerSentenceRange.count, 14)
    }
    
    func test_basically_that_if_the_text_ends_with_a_whole_bunch_of_BlankLines_it_still_returns_from_the_beginning_of_that_group_of_BlankLines_to_the_end_of_that_group_of_BlankLines() {
        let text = """
this is a line.
then one more.
and another one
     
   
  
     
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 55)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 47)
        XCTAssertEqual(innerSentenceRange.count, 18) 
    }
    
    func test_that_if_there_is_no_start_range_found_and_there_is_no_end_range_found_and_the_last_lines_are_a_bunch_of_BlankLines_then_it_returns_from_the_beginning_of_that_group_of_BlankLines_not_including_the_trailing_newline_of_the_last_sentence_with_characters_to_the_end_of_that_group_of_BlankLines() {
        let text = """
no start no end range and trailing blanks
   
   
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 44)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 42)
        XCTAssertEqual(innerSentenceRange.count, 7) 
    }
    
    func test_that_if_there_is_no_start_range_found_and_there_is_no_end_range_found_and_the_last_lines_are_a_bunch_of_BlankLines_then_it_returns_from_the_beginning_of_that_group_of_BlankLines_including_the_trailing_blanks_and_hence_the_trailing_newline_of_the_last_sentence_with_characters_to_the_end_of_that_group_of_BlankLines() {
        let text = """
no start no end range and trailing blanks    
   
   
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 52)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 41)
        XCTAssertEqual(innerSentenceRange.count, 12) 
    }
    
    func test_that_if_there_is_a_start_range_found_but_there_is_no_end_range_found_and_the_last_lines_are_a_bunch_of_BlankLines_then_it_returns_from_the_beginning_of_that_group_of_BlankLines_including_the_trailing_blanks_of_the_last_sentence_with_characters_to_the_end_of_that_group_of_BlankLines() {
        let text = """
    there's a dot there.  
  
   
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 31)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 24)
        XCTAssertEqual(innerSentenceRange.count, 9) 
    }

}


// TextViews
// surrounded by EmptyLines
extension FT_innerSentence_OnBlankLines_Tests {

    func test_that_if_the_text_ends_with_BlankLines_and_that_before_them_there_is_an_EmptyLine_then_it_returns_from_the_beginning_of_that_group_of_BlankLines_to_the_end_of_the_text() {
        let text = """
this is a line.
then one more.
and another one  
  

  
     
"""
            
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 57)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 53)
        XCTAssertEqual(aSentenceRange.count, 8) 
    }
    
    func test_that_if_the_text_ends_with_an_EmptyLine_below_a_group_of_BlankLines_and_that_before_them_there_is_also_an_EmptyLine_then_it_returns_from_the_beginning_of_that_group_of_BlankLines_to_the_end_of_that_group_of_BlankLines_not_including_the_trailing_newline() {
        let text = """
this is a line.
then one more.
and another one  
  

  
     

"""
            
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 57)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 53)
        XCTAssertEqual(aSentenceRange.count, 8) 
    }
    
    func test_that_if_the_text_ends_with_two_EmptyLines_below_a_group_of_BlankLines_and_that_before_them_there_is_also_an_EmptyLine_then_it_returns_from_the_beginning_of_the_EmptyLine_to_the_first_Blank_of_the_next_line_included() {
        let text = """
this is a line.
then one more.
and another one  
  

  
     




"""
            
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 57)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 53)
        XCTAssertEqual(aSentenceRange.count, 8) 
    }
    
}
