@testable import AccessibilityStrategy
import XCTest


// this func is on TO so it's used by both Lines and Texts
// so they're both tested here. sometimes the test calls element.currentFileLine,
// sometimes element.currentFileText
class TexObject_next_Tests: XCTestCase {}


// Both
extension TexObject_next_Tests {
    
    func test_that_in_normal_setting_it_returns_the_correct_location() {
        let text = "check if f can find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 10,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )
        )
                
        let characterFoundLocation = element.currentFileLine.next("i", after: 10)
        
        XCTAssertEqual(characterFoundLocation, 16)        
    }
    
    func test_that_if_we_already_are_on_the_character_we_are_looking_then_we_get_the_location_of_the_next_occurrence() {
        let text = "check if f can find f!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 22,
            caretLocation: 9,
            selectedLength: 1,
            selectedText: "f",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 22,
                number: 1,
                start: 0,
                end: 22
            )
        )
                
        let characterFoundLocation = element.fileText.next("f", after: 9)
        
        XCTAssertEqual(characterFoundLocation, 15)     
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
            caretLocation: 24,
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
        
        let characterFoundLocation = element.currentFileLine.next("z", after: 24)

        XCTAssertEqual(characterFoundLocation, nil)
    }
    
    func test_that_if_we_are_at_the_end_of_the_line_we_get_nil() {
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
                number: 1,
                start: 0,
                end: 24
            )
        )
        
        let characterFoundLocation = element.fileText.next("r", after: 24)

        XCTAssertEqual(characterFoundLocation, nil)
    }
    
    func test_that_if_we_are_at_the_endLimit_of_the_line_we_get_nil_even_if_the_last_character_is_the_one_we_are_looking_for() {
        let text = "caret at the endLinit of line"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 3,
                start: 25,
                end: 29
            )
        )
                
        let characterFoundLocation = element.currentFileLine.next("e", after: 28)
        
        XCTAssertEqual(characterFoundLocation, nil)        
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
        
        let characterFoundLocation = element.currentFileLine.next("a", after: 0)
        
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
        
        let characterFoundLocation = element.fileText.next("r", after: 69)
        
        XCTAssertNil(characterFoundLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension TexObject_next_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "check if f can 😂️ find ☹️!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 27,
            caretLocation: 2,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 1,
                start: 0,
                end: 11
            )
        )
        
        let characterFoundLocation = element.currentFileLine.next("d", after: 2)
        
        XCTAssertEqual(characterFoundLocation, 22)
    }
    
}
