@testable import AccessibilityStrategy
import XCTest


// TODO: make those tests better (multilines)
class FL_previous_Tests: XCTestCase {}


extension FL_previous_Tests {
    
    func test_that_in_normal_setting_it_returns_the_correct_location() {
        let text = "check if F can find shit!"
        
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 12)
        let characterFoundLocation = fileLine.previous("i", before: 12)
        
        XCTAssertEqual(characterFoundLocation, 6)     
    }
    
    func test_that_if_we_already_are_on_the_character_we_are_looking_for_then_we_get_the_location_of_the_previous_occurence() {
        let text = "For Fuck's sake F!!!"
        
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 12)
        let characterFoundLocation = fileLine.previous("F", before: 12)
        
        XCTAssertEqual(characterFoundLocation, 4)   
    }
    
    func test_that_if_it_cannot_find_the_character_then_we_get_nil() {
        let text = """
can't find character
here so caret shouldn't move
"""
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 22)
        let characterFoundLocation = fileLine.previous("z", before: 22)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_if_we_are_at_the_beginning_of_the_line_then_we_get_nil() {
        let text = "at the beginning of the line!"
        
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 0)
        let characterFoundLocation = fileLine.previous("z", before: 0)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    
    // TODO: failable init again?
    func test_that_if_we_are_out_of_bound_we_get_nil() throws {
        throw XCTSkip("need failable init")
        
        let text = "caret at the end of line"
        
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 69)        
        let characterFoundLocation = fileLine.previous("r", before: 69)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_it_returns_nil_for_an_empty_line() {
        let text = ""
        
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 0)        
        let characterFoundLocation = fileLine.previous("a", before: 0)
        
        XCTAssertNil(characterFoundLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_previous_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "check if f can 😂️ find ☹️!"
        
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 12)        
        let characterFoundLocation = fileLine.previous("h", before: 26)
        
        XCTAssertEqual(characterFoundLocation, 1)
    }
    
}
