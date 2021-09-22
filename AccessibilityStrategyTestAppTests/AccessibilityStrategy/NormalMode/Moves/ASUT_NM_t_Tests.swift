@testable import AccessibilityStrategy
import XCTest


// see F for blah blah
class ASUT_NM_t_Tests: ASNM_BaseTests {
    
    private func applyMove(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.t(to: character, on: element) 
    }
    
}


// Both
extension ASUT_NM_t_Tests {
    
    func test_that_in_normal_setting_it_moves_the_caret_before_the_first_occurence_of_the_character_found_to_the_right() {
        let text = "check if t can find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 10,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 1,
                start: 0,
                end: 25
            )
        )        
        
        let returnedElement = applyMove(to: "i", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 15)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_character_is_not_found_then_the_caret_does_not_move() {
        let text = """
gonna look
for a character
that is not there
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "c",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 2,
                start: 11,
                end: 27
            )
        )        
        
        let returnedElement = applyMove(to: "z", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 22)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_t_Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let text = """
fFtT should
work on multilines
without crashing
yeah
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 52,
            caretLocation: 31,
            selectedLength: 1,
            selectedText: "w",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 3,
                start: 31,
                end: 48
            )
        )
        
        let returnedElement = applyMove(to: "a", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 40)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// emojis
extension ASUT_NM_t_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
need to deal with
those 🍃️🍃️🍃️🍃️🍃️🍃️ f🚀️ces 🥺️☹️😂️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 59,
            caretLocation: 21,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 2,
                start: 18,
                end: 59
            )
        )
        
        let returnedElement = applyMove(to: "c", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 44)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
