@testable import AccessibilityStrategy
import XCTest


class FileLine_previous_Tests: XCTestCase {}


// Both
extension FileLine_previous_Tests {
    
    func test_that_in_normal_setting_it_returns_the_correct_location() {
        let text = "check if F can find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )
        )
        
        let characterFoundLocation = element.currentFileLine.previous("i", before: 12)
        
        XCTAssertEqual(characterFoundLocation, 6)     
    }
    
    func test_that_if_we_already_are_on_the_character_we_are_looking_for_then_we_get_the_location_of_the_previous_occurence() {
        let text = "For Fuck's sake F!!!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 20,
            caretLocation: 16,
            selectedLength: 1,
            selectedText: "F",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 20,
                number: 1,
                start: 0,
                end: 20
            )
        )
                
        let characterFoundLocation = element.currentFileLine.previous("F", before: 12)
        
        XCTAssertEqual(characterFoundLocation, 4)   
    }
    
    func test_that_if_it_cannot_find_the_character_then_we_get_nil() {
        let text = """
can't find character
here so caret shouldn't move
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 49,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 49,
                number: 3,
                start: 21,
                end: 29
            )
        )
        
        let characterFoundLocation = element.currentFileLine.previous("z", before: 22)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_if_we_are_at_the_beginning_of_the_line_then_we_get_nil() {
        let text = "at the beginning of the line!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 1,
                start: 0,
                end: 7
            )
        )
                
        let characterFoundLocation = element.currentFileLine.previous("z", before: 0)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_if_we_are_out_of_bound_we_get_nil() {
        let text = "caret at the end of line"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 24,
            caretLocation: 24,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 24,
                number: 2,
                start: 13,
                end: 24
            )
        )
        
        let characterFoundLocation = element.currentFileLine.previous("r", before: 69)
        
        XCTAssertNil(characterFoundLocation)
    }
    
    func test_that_it_returns_nil_for_an_empty_line() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )
        )
        
        let characterFoundLocation = element.currentFileLine.previous("a", before: 0)
        
        XCTAssertNil(characterFoundLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FileLine_previous_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "check if f can 😂️ find ☹️!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 27,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: "!",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 3,
                start: 24,
                end: 27
            )
        )
        
        let characterFoundLocation = element.currentFileLine.previous("h", before: 26)
        
        XCTAssertEqual(characterFoundLocation, 1)
    }
    
}
