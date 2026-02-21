@testable import AccessibilityStrategy
import XCTest


class FT_innerSentence_OnBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerSentence(startingAt: caretLocation)
    }
    
}


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
    
    func test_basically_that_if_the_text_starts_with_a_whole_bunch_of_BlankLines_it_still_returns_from_the_beginning_of_the_text_to_the_end_of_first_sentence_with_characters_not_including_trailing_blanks_nor_the_trailing_newline() {
        let text = """
  
    
      
this is a line.  
then one more.
and another one.
"""
        
        let innerSentence = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(innerSentence.lowerBound, 0)
        XCTAssertEqual(innerSentence.count, 30) 
    }
    
    func test_that_if_there_is_no_start_range_found_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_sentence_with_characters_that_is_below_the_BlankLine() {
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
    
}
