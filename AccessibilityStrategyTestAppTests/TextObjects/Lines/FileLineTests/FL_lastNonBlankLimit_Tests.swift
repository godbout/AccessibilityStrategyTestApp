@testable import AccessibilityStrategy
import XCTest



class FL_lastNonBlankLimit_Tests: XCTestCase {}


// TextFields and TextViews
extension FL_lastNonBlankLimit_Tests {

    func test_that_it_returns_the_correct_location_for_a_line_that_ends_with_a_non_blank_character() throws {
        let text = "hehe motherfuckers"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 7)
        )
        
        XCTAssertEqual(fileLine.lastNonBlankLimit, 17)     
    }
    
    func test_that_if_the_line_ends_with_spaces_it_returns_the_correct_location() throws {
        let text = "hehe motherfuckers but with spaces         "
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 7)
        )
        
        XCTAssertEqual(fileLine.lastNonBlankLimit, 33)     
    }
    
}


// TextViews
extension FL_lastNonBlankLimit_Tests {

    func test_that_if_the_line_ends_with_a_Newline_it_still_returns_the_correct_location() throws {
        let text = """
hehe motherfuckers but with linefeed

""" 
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 7)
        )
        
        XCTAssertEqual(fileLine.lastNonBlankLimit, 35)     
    }
    
    func test_that_if_the_line_ends_with_Blanks_and_a_Newline_it_still_returns_the_correct_location() throws {
        let text = """
hehe motherfuckers but with spaces and linefeed!       

"""
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 7)
        )
        
        XCTAssertEqual(fileLine.lastNonBlankLimit, 47)
    }
    
    func test_that_if_the_line_it_just_spaces_then_it_returns_the_beginning_of_the_line() throws {
        let text = """
hehe motherfuckers but with spaces and linefeed!       
                
fucking blank line above
"""
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 63)
        )
        
        XCTAssertEqual(fileLine.lastNonBlankLimit, 56)
    }
    
}
