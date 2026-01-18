@testable import AccessibilityStrategy
import XCTest


class FL_previous_Tests: XCTestCase {}


// TextFields and TextViews
extension FL_previous_Tests {
    
    func test_that_in_normal_setting_it_returns_the_correct_location() throws {
        let text = "check if F can find shit!"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 12)
        )
        let characterFoundLocation = fileLine.previous("i", before: 12)
        
        XCTAssertEqual(characterFoundLocation, 6)     
    }
    
    func test_that_if_we_already_are_on_the_character_we_are_looking_for_then_we_get_the_location_of_the_previous_occurence() throws {
        let text = "For Fuck's sake F!!!"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 12)
        )
        let characterFoundLocation = fileLine.previous("F", before: 12)
        
        XCTAssertEqual(characterFoundLocation, 4)   
    }
    
    func test_that_if_it_cannot_find_the_character_then_we_get_nil() throws {
        let text = """
can't find character
here so caret shouldn't move
"""
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 22)
        )
        let characterFoundLocation = fileLine.previous("z", before: 22)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_if_we_are_at_the_beginning_of_the_line_then_we_get_nil() throws {
        let text = "at the beginning of the line!"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 0)
        )
        let characterFoundLocation = fileLine.previous("z", before: 0)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_if_we_are_out_of_bound_we_get_nil() throws {
        let text = "caret at the end of line"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 3)
        )
        let characterFoundLocation = fileLine.previous("r", before: 69)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_it_returns_nil_for_an_EmptyLine() throws {
        let text = ""
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 0)
        )
        let characterFoundLocation = fileLine.previous("a", before: 0)
        
        XCTAssertNil(characterFoundLocation)
    }
    
}


// TextViews
extension FL_previous_Tests {
    
    func test_that_it_sticks_to_its_line_and_does_not_look_before_that_line() throws {
        let text = """
so if i get this right that shits should search
on its own line else it's gay
"""
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 64)
        )
        let characterFoundLocation = fileLine.previous("a", before: 64)
        
        XCTAssertNil(characterFoundLocation)
        
    }
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_previous_Tests {
    
    func test_that_it_handles_emojis() throws {
        let text = "check if f can 😂️ find ☹️!"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 12)
        )
        let characterFoundLocation = fileLine.previous("h", before: 26)
        
        XCTAssertEqual(characterFoundLocation, 1)
    }
    
}
