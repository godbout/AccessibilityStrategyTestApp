@testable import AccessibilityStrategy
import XCTest


class FL_next_Tests: XCTestCase {}


// Both
extension FL_next_Tests {
    
    func test_that_in_normal_setting_it_returns_the_correct_location() throws {
        let text = "check if f can find shit!"       
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 10)
        )
        let characterFoundLocation = fileLine.next("i", after: 10)
        
        XCTAssertEqual(characterFoundLocation, 16)        
    }
    
    func test_that_if_we_already_are_on_the_character_we_are_looking_then_we_get_the_location_of_the_next_occurrence() throws {
        let text = "check if f can find f!"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 9)
        )
        let characterFoundLocation = fileLine.next("f", after: 9)
        
        XCTAssertEqual(characterFoundLocation, 15)     
    }
    
    func test_that_if_it_cannot_find_the_character_then_we_get_nil() throws {
        let text = """
can't find character
here so caret shouldn't move
"""
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 24)
        )
        let characterFoundLocation = fileLine.next("z", after: 24)

        XCTAssertEqual(characterFoundLocation, nil)
    }
    
    func test_that_if_we_are_at_the_end_of_the_line_we_get_nil() throws {
        let text = "caret at the end of line"

        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 24)
        )
        let characterFoundLocation = fileLine.next("r", after: 24)

        XCTAssertEqual(characterFoundLocation, nil)
    }
    
    func test_that_if_we_are_at_the_endLimit_of_the_line_we_get_nil_even_if_the_last_character_is_the_one_we_are_looking_for() throws {
        let text = "caret at the endLinit of line"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 28)
        )
        let characterFoundLocation = fileLine.next("e", after: 28)
        
        XCTAssertEqual(characterFoundLocation, nil)        
    }
    
    func test_that_it_returns_nil_for_an_EmptyLine() throws {
        let text = ""
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 0)
        )
        let characterFoundLocation = fileLine.next("a", after: 0)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    
    func test_that_if_we_are_out_of_bound_we_get_nil() throws {
        let text = "caret at the end of line"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 5)
        )
        let characterFoundLocation = fileLine.next("r", after: 69)
        
        XCTAssertNil(characterFoundLocation)
    }
    
}


// TextViews
extension FL_next_Tests {
    
    func test_that_it_sticks_to_its_line_and_does_not_look_after_that_line() throws {
        let text = """
so if i get this right that shits should search
on its own line else it's gay
"""
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 4)
        )
        let characterFoundLocation = fileLine.next("y", after: 4)
        
        XCTAssertNil(characterFoundLocation)
        
    }
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_next_Tests {
    
    func test_that_it_handles_emojis() throws {
        let text = "check if f can 😂️ find ☹️!"

        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 2)
        )
        let characterFoundLocation = fileLine.next("d", after: 2)
        
        XCTAssertEqual(characterFoundLocation, 22)
    }
    
}
