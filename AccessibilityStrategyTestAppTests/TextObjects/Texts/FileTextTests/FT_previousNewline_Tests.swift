@testable import AccessibilityStrategy
import XCTest


// see previousNewline for blah blah
class FT_previousNewline_Tests: XCTestCase {}


// TextFields
extension FT_previousNewline_Tests {
    
    func test_that_if_we_are_on_a_single_line_without_any_newline_then_it_returns_nil() {
        let text = "this is a single line without any newline lol"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.previousNewline(before: 3)
        
        XCTAssertNil(newlineFoundLocation)
    }
        
    func test_that_if_we_are_at_the_beginning_of_the_line_we_still_get_nil() {
        let text = "caret at the end of line"

        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.previousNewline(before: 0)

        XCTAssertEqual(newlineFoundLocation, nil)
    }
    
    func test_that_it_returns_nil_for_an_EmptyLine() throws {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.previousNewline(before: 0)
        
        XCTAssertNil(newlineFoundLocation)
    }
    
    func test_that_if_we_are_out_of_bound_we_get_nil() throws {
        let text = "caret at the end of line"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.previousNewline(before: 69)
        
        XCTAssertNil(newlineFoundLocation)
    }
    
}


// TextViews
extension FT_previousNewline_Tests {
    
    func test_that_for_multiple_lines_it_finds_the_previous_newline() {
        let text = """
so ok finally
here we go
    multiple lines!
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.previousNewline(before: 22)
        
        XCTAssertEqual(newlineFoundLocation, 13)
    }
    
    func test_that_if_on_an_EmptyLine_it_does_not_get_stuck_and_find_the_previous_newline() {
        let text = """
here we have a line

and an empty one above
rad
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.previousNewline(before: 20)
        
        XCTAssertEqual(newlineFoundLocation, 19)
    }
    
    func test_thatif_we_have_consecutive_EmptyLines_it_returns_the_correct_previous_newline() {
        let text = """
ok now multiple EL



here we go
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.previousNewline(before: 20)
        
        XCTAssertEqual(newlineFoundLocation, 19)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_previousNewline_Tests {
    
    func test_that_it_handles_emojis() throws {
        let text = """
another
check if f can 😂️ find ☹️!
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.previousNewline(before: 30)
        
        XCTAssertEqual(newlineFoundLocation, 7)
    }
    
}
