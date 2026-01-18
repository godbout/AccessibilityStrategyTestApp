@testable import AccessibilityStrategy
import XCTest


// FL and SL use the same TO firstNonBlankLimit func
// but i'm testing each type of Line independently. both ways to test
// are valid but i find it harder to understand/remember if the tests are done
// on the Protocol rather than on the Line types.
class FL_firstNonBlankLimit_Tests: XCTestCase {}


// TextFields and TextViews
extension FL_firstNonBlankLimit_Tests {
    
    func test_that_if_the_line_starts_with_spaces_it_returns_the_correct_location() throws {
        let text = "     some spaces are found at the beginning of this text"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 18)
        )
        
        XCTAssertEqual(fileLine.firstNonBlankLimit, 5)     
    }
    
    func test_that_if_the_line_starts_with_a_tab_character_it_still_returns_the_correct_location() throws {
        let text = "\t\ttwo tabs now are found at the beginning of this text"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 38)
        )
        
        XCTAssertEqual(fileLine.firstNonBlankLimit, 2)   
    }
    
    func test_that_if_the_line_starts_with_a_fucking_mix_of_tabs_and_spaces_it_still_returns_the_correct_location() throws {
        let text = "  \twho writes shits like this?"        
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 23)
        )
        
        XCTAssertEqual(fileLine.firstNonBlankLimit, 3)   
    }
    
    func test_that_if_the_line_starts_with_non_blank_characters_then_the_caret_location_is_0() throws {
        let text = "non whitespace at the beginning here"        
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 18)
        )               
        
        XCTAssertEqual(fileLine.firstNonBlankLimit, 0)
    }
    
    func test_that_if_the_line_is_empty_it_returns_0() throws {
        let text = ""        
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 0)
        )        
        
        XCTAssertEqual(fileLine.firstNonBlankLimit, 0)
    }
    
    func test_that_if_the_line_only_contains_it_returns_the_end_limit() throws {
        let text = "        "        
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 4)
        )                
        
        XCTAssertEqual(fileLine.firstNonBlankLimit, 7)
    }
    
    func test_that_if_the_line_only_contains_spaces_and_ends_with_a_linefeed_it_returns_the_end_limit() throws {
        let text = "     \n"        
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 4)
        )
        
        XCTAssertEqual(fileLine.firstNonBlankLimit, 4)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
// actually for blank stuff it doesn't really matter, but at least
// the test is here so i'll not wonder later why there's none :D
extension FL_firstNonBlankLimit_Tests {
    
    func test_that_it_handles_emojis() throws {
        let text = "                🔫️🔫️🔫️ are "        
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 22)
        )        
        
        XCTAssertEqual(fileLine.firstNonBlankLimit, 16)
    }
    
}
