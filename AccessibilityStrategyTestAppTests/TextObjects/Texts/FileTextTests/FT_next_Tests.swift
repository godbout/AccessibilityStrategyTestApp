@testable import AccessibilityStrategy
import XCTest

// TODO: this is pasted from FL. need to be adapted for FT
class FT_next_Tests: XCTestCase {}


// Both
extension FT_next_Tests {
    
    func test_that_in_normal_setting_it_returns_the_correct_location() {
        let text = "check if f can find shit!"       
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.next("i", after: 10)
        
        XCTAssertEqual(characterFoundLocation, 16)        
    }
    
    func test_that_if_we_already_are_on_the_character_we_are_looking_then_we_get_the_location_of_the_next_occurrence() {
        let text = "check if f can find f!"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.next("f", after: 9)
        
        XCTAssertEqual(characterFoundLocation, 15)     
    }
    
    func test_that_if_it_cannot_find_the_character_then_we_get_nil() {
        let text = """
can't find character
here so caret shouldn't move
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.next("z", after: 24)

        XCTAssertEqual(characterFoundLocation, nil)
    }
    
    func test_that_if_we_are_at_the_end_of_the_line_we_get_nil() {
        let text = "caret at the end of line"

        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.next("r", after: 24)

        XCTAssertEqual(characterFoundLocation, nil)
    }
    
    func test_that_if_we_are_at_the_endLimit_of_the_line_we_get_nil_even_if_the_last_character_is_the_one_we_are_looking_for() {
        let text = "caret at the endLinit of line"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.next("e", after: 28)
        
        XCTAssertEqual(characterFoundLocation, nil)        
    }
    
    func test_that_it_returns_nil_for_an_empty_line() {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.next("a", after: 0)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_if_we_are_out_of_bound_we_get_nil() throws {
        throw XCTSkip("need failable init")
        
        let text = "caret at the end of line"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.next("r", after: 69)
        
        XCTAssertNil(characterFoundLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_next_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "check if f can 😂️ find ☹️!"

        let fileText = FileText(end: text.utf16.count, value: text)
        let characterFoundLocation = fileText.next("d", after: 2)
        
        XCTAssertEqual(characterFoundLocation, 22)
    }
    
}
