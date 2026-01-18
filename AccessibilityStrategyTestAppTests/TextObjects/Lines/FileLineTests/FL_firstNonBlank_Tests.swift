@testable import AccessibilityStrategy
import XCTest


// that func is actually on FileObject, but we test it both
// separately on FL and FT because it makes more sense to me
// rather than testing on the protocol.
class FL_firstNonBlank_Tests: XCTestCase {}


// TextFields and TextViews
extension FL_firstNonBlank_Tests {
    
    func test_that_if_the_line_starts_with_spaces_it_returns_the_correct_location() throws {
        let text = "     some spaces are found at the beginning of this text"

        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 23)
        )
        
        XCTAssertEqual(fileLine.firstNonBlank, 5)
    }
    
    func test_that_if_the_line_starts_with_a_tab_character_it_still_returns_the_correct_location() throws {
        let text = "\t\ttwo tabs now are found at the beginning of this text"

        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 17)
        )
        
        XCTAssertEqual(fileLine.firstNonBlank, 2)
    }
    
    func test_that_if_the_line_starts_with_a_fucking_mix_of_tabs_and_spaces_it_still_returns_the_correct_location() throws {
        let text = "  \twho writes shits like this?"

        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 11)
        )
        
        XCTAssertEqual(fileLine.firstNonBlank, 3)
    }
    
    func test_that_if_the_line_starts_with_non_blank_characters_then_the_caret_location_is_0() throws {
        let text = "non whitespace at the beginning here"

        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 30)
        )
        
        XCTAssertEqual(fileLine.firstNonBlank, 0)
    }
    
    func test_that_if_the_line_is_empty_it_returns_nil() throws {
        let text = ""

        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 0)
        )
        
        XCTAssertNil(fileLine.firstNonBlank)
    }
   
    func test_that_if_the_TextField_only_contains_spaces_it_returns_nil() throws {
        let text = "        "

        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 5)
        )
        
        XCTAssertNil(fileLine.firstNonBlank)
    }
    
}


// TextViews
extension FL_firstNonBlank_Tests {
    
    func test_that_for_a_line_with_linefeed_the_caret_goes_to_the_end_of_the_line_before_the_linefeed() throws {
        let text = """
            
and a line is empty!
"""

        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 7)
        )
        
        XCTAssertEqual(fileLine.firstNonBlank, 12)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_firstNonBlank_Tests {
    
    // actually this function especially doesn't need anything special to handle emojis as it is counting only
    // the blank characters and will stop at the first non blank found. still for consistency so that i'm not wondering
    // later here it is.
    func test_that_it_handles_emojis() throws {
        let text = "     😂️"

        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 1)
        )
        
        XCTAssertEqual(fileLine.firstNonBlank, 5)
    }
    
}
