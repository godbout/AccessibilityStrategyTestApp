@testable import AccessibilityStrategy
import XCTest

// see next for blah blah
class FT_previous_Tests: XCTestCase {}


// Both
extension FT_previous_Tests {
    
    func test_that_in_normal_setting_it_returns_the_correct_location() {
        let text = "check if F can find shit!"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.previous("i", before: 12)
        
        XCTAssertEqual(characterFoundLocation, 6)     
    }
    
    func test_that_if_we_already_are_on_the_character_we_are_looking_for_then_we_get_the_location_of_the_previous_occurence() {
        let text = "For Fuck's sake F!!!"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.previous("F", before: 12)
        
        XCTAssertEqual(characterFoundLocation, 4)   
    }
    
    func test_that_if_it_cannot_find_the_character_then_we_get_nil() {
        let text = """
can't find character
here so caret shouldn't move
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.previous("z", before: 22)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_if_we_are_at_the_beginning_of_the_line_then_we_get_nil() {
        let text = "at the beginning of the line!"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.previous("z", before: 0)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    
    // TODO: failable init again?
    func test_that_if_we_are_out_of_bound_we_get_nil() throws {
        throw XCTSkip("need failable init")
        
        let text = "caret at the end of line"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.previous("r", before: 69)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_it_returns_nil_for_an_empty_line() {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.previous("a", before: 0)
        
        XCTAssertNil(characterFoundLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_previous_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "check if f can 😂️ find ☹️!"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.previous("h", before: 26)
        
        XCTAssertEqual(characterFoundLocation, 1)
    }
    
}
