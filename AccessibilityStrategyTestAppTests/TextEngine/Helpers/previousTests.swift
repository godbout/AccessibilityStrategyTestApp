@testable import AccessibilityStrategy
import XCTest


class previousTests: TextEngineBaseTests {}


// Both
extension previousTests {
    
    func test_that_in_normal_setting_it_returns_the_correct_location() {
        let text = "check if F can find shit!"
        let location = textEngine.previous("i", before: 12, in: text)
        
        XCTAssertEqual(location, 6)     
    }
    
    func test_that_if_we_already_are_on_the_character_we_are_looking_for_then_we_get_the_location_of_the_previous_occurence() {
        let text = "For Fuck's sake F!!!"
        let location = textEngine.previous("F", before: 16, in: text)
        
        XCTAssertEqual(location, 4)   
    }
    
    func test_that_if_it_cannot_find_the_character_then_we_get_nil() {
        let text = """
can't find character
here so caret shouldn't move
"""
        let location = textEngine.previous("z", before: 22, in: text)
        
        XCTAssertEqual(location, nil)
    }
    
    func test_that_if_we_are_at_the_beginning_of_the_line_then_we_get_nil() {
        let text = "at the beginning of the line!"
        let location = textEngine.previous("z", before: 0, in: text)
        
        XCTAssertEqual(location, nil)
    }
    
    func test_that_if_we_are_out_of_bound_we_get_nil() {
        let text = "caret at the end of line"
        let location = textEngine.previous("r", before: 69, in: text)
        
        XCTAssertEqual(location, nil)
    }
    
    func test_that_it_returns_nil_for_an_empty_line() {
        let text = ""
        
        let location = textEngine.previous("a", before: 0, in: text)
        
        XCTAssertNil(location)
    }
    
}

// TextViews
extension previousTests {
    
    func test_that_it_gets_the_right_location_even_for_multilines() {
        let text = """
now we gonna test
that we can get previous
character even on multilines
"""
        let location = textEngine.previous("w", before: 59, in: text)
        
        XCTAssertEqual(location, 23)        
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension previousTests {
    
    func test_that_it_handles_emojis() {
        let text = "check if f can 😂️ find ☹️!"
        let location = textEngine.previous("h", before: 26, in: text)
        
        XCTAssertEqual(location, 1)
    }
    
}
