@testable import AccessibilityStrategy
import XCTest


class FT_innerSentence_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_innerSentence_OnEmptyLines_Tests {
    
    func test_that_for_an_EmptyLine_it_returns_the_correct_range() {
        let text = ""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 0) 
    }

}


// TextViews
// basic
extension FT_innerSentence_OnEmptyLines_Tests {
    
    func test_that_if_the_caret_is_on_the_first_EmptyLine_the_text_then_it_returns_just_that_line_lol() {
        let text = """

this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 1) 
    }
    
    func test_that_if_there_is_no_start_range_found_it_returns_just_the_EmptyLine_lol_again() {
        let text = """
first line hehe

above is an EL!
which is a paragraph boundary which
is also a sentence boundary!
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 1)
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
    
    func test_that_if_there_is_no_end_range_found_and_that_there_are_trailing_Blanks_on_the_previous_line_then_it_returns_a_range_from_the_last_NonBlank_character_of_the_previous_line_not_included_to_the_trailing_newline_of_the_previous_line_not_included() {
        let text = """
this is a line.
then one more.
and another one      

"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 53)

        XCTAssertEqual(innerSentenceRange.lowerBound, 46)
        XCTAssertEqual(innerSentenceRange.count, 6)
    }
    
    // TODO: FR
    // 1. think if there's some more cases here for the basic?
    // 2. then we need to start doing surrounded by BLs and ELs :D
    
}
