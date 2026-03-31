@testable import AccessibilityStrategy
import XCTest


class FT_aSentence_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_aSentence_OnEmptyLines_Tests {
    
    func test_that_for_an_EmptyLine_it_returns_the_correct_range() {
        let text = ""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 0) 
    }
    
}


// TextViews
// basic
extension FT_aSentence_OnEmptyLines_Tests {
    
    func test_that_if_the_caret_is_on_the_first_EmptyLine_of_the_text_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_first_sentence_with_characters_not_including_the_trailing_newline() {
        let text = """

this is a line.
then one more.
and another one.
"""
        
        // TODO: FR aSentence not innerSentence :D
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 16) 
    }
    
    func test_that_if_the_caret_is_on_the_first_EmptyLine_of_the_text_and_the_first_normal_sentence_has_leading_blanks_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_first_nonBlank_not_included_of_the_normal_sentence() {
        let text = """

   this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 4) 
    }
    
    func test_that_if_the_caret_is_on_an_EmptyLine_it_returns_from_the_beginning_of_that_EmptyLine_to_the_end_of_the_next_normal_sentence_not_including_the_trailing_newline() {
        let text = """
first line hehe

above is an EL!
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 16)
    }
    
    func test_that_if_the_caret_is_on_an_EmptyLine_it_returns_from_the_beginning_of_that_EmptyLine_to_the_end_of_the_next_normal_sentence_not_including_the_trailing_blanks_and_the_trailine_newline() {
        let text = """
first line hehe

above is an BL not an EL!  
and BL are NOT sentence boundaries!
"""

        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)

        XCTAssertEqual(aSentenceRange.lowerBound, 16)
        XCTAssertEqual(aSentenceRange.count, 26)
    }
    
    func test_that_if_the_caret_is_on_an_EmptyLine_and_there_is_an_end_range_and_the_next_line_starts_with_Blanks_then_it_returns_from_the_beginning_of_the_EmptyLine_to_the_first_NonBlank_not_included_of_the_next_line() {
        let text = """
first line hehe

   above is an EL!
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 4)
    }
    
    func test_that_if_there_is_no_end_range_found_and_that_there_is_no_trailing_Blanks_on_the_previous_line_then_it_returns_a_range_from_the_last_NonBlank_character_of_the_previous_line_included_to_the_trailing_newline_of_the_previous_line_included() {
        let text = """
this is a line.
then one more.
and another one

"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 47)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 45)
        XCTAssertEqual(innerSentenceRange.count, 2) 
    }
    
    func test_that_if_there_is_no_end_range_found_and_that_there_are_trailing_Blanks_on_the_previous_line_then_it_returns_a_range_from_the_last_NonBlank_character_of_the_previous_line_included_to_the_single_next_Blank_character_included_which_is_really_weird() {
        let text = """
this is a line.
then one more.
and another one      

"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 53)

        XCTAssertEqual(innerSentenceRange.lowerBound, 45)
        XCTAssertEqual(innerSentenceRange.count, 2)
    }
    
    func test_that_if_the_caret_is_on_an_EmptyLine_and_there_is_no_end_range_but_after_the_caret_location_there_are_NonBlanks_then_it_returns_from_the_beginning_of_the_EmptyLine_to_the_end_of_the_text() {
        let text = """
first line hehe

and then no
end range
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 22)
    }
    
}


// surrounded by El that fails hehe
//func test_a() {
//    let text = """
//
//
//this is a line.
//then one more.
//and another one.
//"""
//    
//    let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
//    
//    XCTAssertEqual(innerSentenceRange.lowerBound, 1)
//    XCTAssertEqual(innerSentenceRange.count, 4) 
//}

