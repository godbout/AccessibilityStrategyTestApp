@testable import AccessibilityStrategy
import XCTest


// see F for blah blah
class ASUT_NM_f_Tests: ASNM_BaseTests {
    
    private func applyMove(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.f(to: character, on: element) 
    }
    
}


// Both
extension ASUT_NM_f_Tests {
    
    func test_that_in_normal_setting_it_moves_the_caret_to_the_first_occurence_of_the_character_found_to_the_right() {
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
        
        
        let returnedElement = applyMove(to: "i", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 16)
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
                fullTextValue: text,
                fullTextLength: 44,
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
extension ASUT_NM_f_Tests {
    
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
            caretLocation: 48,
            selectedLength: 1,
            selectedText: "y",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 4,
                start: 48,
                end: 52
            )
        )
        
        let returnedElement = applyMove(to: "h", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 51)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// emojis
extension ASUT_NM_f_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
need to deal with
those 🍃️🍃️🍃️🍃️🍃️🍃️ faces 🥺️☹️😂️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 57,
            caretLocation: 21,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 2,
                start: 18,
                end: 57
            )
        )
        
        let returnedElement = applyMove(to: "c", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 45)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
