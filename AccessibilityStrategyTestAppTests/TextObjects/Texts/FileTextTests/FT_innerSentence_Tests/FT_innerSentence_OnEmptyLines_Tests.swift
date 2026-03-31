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
    
    func test_that_if_the_caret_is_on_the_first_EmptyLine_of_the_text_then_it_returns_just_that_line_lol() {
        let text = """

this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 1) 
    }
    
    func test_that_if_the_caret_is_on_the_first_EmptyLine_and_the_next_line_starts_with_Blanks_then_it_returns_from_the_beginning_of_the_text_to_the_first_NonBlank_from_the_next_line() {
        let text = """

   this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 4) 
    }
    
    func test_that_if_the_caret_is_on_an_EmptyLine_and_there_is_an_end_range_then_it_returns_just_the_EmptyLine() {
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
    
    func test_that_if_the_caret_is_on_an_EmptyLine_and_there_is_no_end_range_but_after_the_caret_location_there_are_NonBlanks_then_it_returns_just_the_EmptyLine() {
        let text = """
first line hehe

and then no
end range
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 16)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 1)
    }
    
}


// TextViews
// surrounded by BlankLines
extension FT_innerSentence_OnEmptyLines_Tests {
    
    
}


// TextViews
// surrounded by EmptyLines
extension FT_innerSentence_OnEmptyLines_Tests {
    
    func test_that_if_the_text_starts_with_multiple_EmptyLines_then_it_returns_from_the_beginning_of_the_EmptyLine_where_the_caret_is_to_the_last_EmptyLine_included_that_is_before_a_normal_line() {
        let text = """





this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 2)
        XCTAssertEqual(innerSentenceRange.count, 3) 
    }

    // TODO: FR this one is failing and also see Things to think if we actually bother doing all those ones for now
    // or if we jump direcly on the `as` Basic
    func test_that_if_the_text_starts_with_multiple_EmptyLines_and_the_caret_is_two_lines_above_the_first_normal_line_then_it_returns_from_the_beginning_of_the_EmptyLine_where_the_caret_is_to_the_last_EmptyLine_included_that_is_before_a_normal_line_and_that_means_that_it_does_NOT_include_the_leading_blanks_from_the_following_normal_line() {
        let text = """





   this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 3)
        XCTAssertEqual(innerSentenceRange.count, 2) 
    }

    func test_that_if_the_text_starts_with_multiple_EmptyLines_and_the_caret_is_three_lines_above_the_first_normal_line_then_it_returns_from_the_beginning_of_the_EmptyLine_where_the_caret_is_to_the_last_EmptyLine_included_that_is_before_a_normal_line_and_that_means_that_it_does_NOT_include_the_leading_blanks_from_the_following_normal_line() {
        let text = """





   this is a line.
then one more.
and another one.
"""
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 2)
        XCTAssertEqual(innerSentenceRange.count, 3) 
    }

}
