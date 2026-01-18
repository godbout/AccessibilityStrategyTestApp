@testable import AccessibilityStrategy
import XCTest


// this one and previousNewline only exist on FileText, not FileObjectProtocol
// coz it makes no sense (or at least currently useless) for FileLine.
// coz you know, newline. FL acts on a line, lines which are separated by newlines.
// so yeah. everything is at its right place.
class FT_nextNewline_Tests: XCTestCase {}


// TextFields
extension FT_nextNewline_Tests {
    
    func test_that_if_we_are_on_a_single_line_without_any_newline_then_it_returns_nil() {
        let text = "this is a single line without any newline lol"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.nextNewline(after: 3)
        
        XCTAssertNil(newlineFoundLocation)
    }
        
    func test_that_if_we_are_at_the_end_of_the_line_we_still_get_nil() {
        let text = "caret at the end of line"

        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.nextNewline(after: 24)

        XCTAssertEqual(newlineFoundLocation, nil)
    }
    
    func test_that_if_we_are_at_the_endLimit_of_the_line_we_still_get_nil() {
        let text = "caret at the endLinit of line"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.nextNewline(after: 28)
        
        XCTAssertEqual(newlineFoundLocation, nil)        
    }
    
    func test_that_it_returns_nil_for_an_EmptyLine() throws {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.nextNewline(after: 0)
        
        XCTAssertNil(newlineFoundLocation)
    }
    
    func test_that_if_we_are_out_of_bound_we_get_nil() throws {
        let text = "caret at the end of line"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.nextNewline(after: 69)
        
        XCTAssertNil(newlineFoundLocation)
    }
    
}


// TextViews
extension FT_nextNewline_Tests {
    
    func test_that_for_multiple_lines_it_finds_the_next_newline() {
        let text = """
so ok finally
here we go
    multiple lines!
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.nextNewline(after: 3)
        
        XCTAssertEqual(newlineFoundLocation, 13)
    }
    
    func test_that_if_on_an_EmptyLine_it_does_not_get_stuck_and_find_the_next_newline() {
        let text = """
here we have a line

and an empty one above
rad
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.nextNewline(after: 20)
        
        XCTAssertEqual(newlineFoundLocation, 43)
    }
    
    func test_thatif_we_have_consecutive_EmptyLines_it_returns_the_correct_following_newline() {
        let text = """
ok now multiple EL



here we go
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.nextNewline(after: 20)
        
        XCTAssertEqual(newlineFoundLocation, 21)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_nextNewline_Tests {
    
    func test_that_it_handles_emojis() throws {
        let text = """
check if f can 😂️ find ☹️!
another
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let newlineFoundLocation = fileText.nextNewline(after: 6)
        
        XCTAssertEqual(newlineFoundLocation, 27)
    }
    
}
