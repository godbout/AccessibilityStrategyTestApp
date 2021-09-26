@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_0_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.zero(on: element) 
    }
    
}


// Both
extension ASUT_NM_0_Tests {

    func test_that_in_normal_setting_0_is_moving_the_caret_position_to_the_first_character_of_the_line() {
        let text = "0 should send us to the beginning of the line"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 45,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 45,
                number: 1,
                start: 0,
                end: 45
            )
        )

        let returnedElement = applyMove(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }    

}

// TextViews
extension ASUT_NM_0_Tests {

    func test_that_at_the_beginning_of_a_line_zero_does_not_move() {
        let text = """
multiline
where we gonna test 0
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 10,
            selectedLength: 1,
            selectedText: "w",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 2,
                start: 10,
                end: 31
            )
        )
        let returnedElement = applyMove(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 10)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }

}


// emojis
extension ASUT_NM_0_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
need to deal with
🌱️those 🍃️🍃️🍃️🍃️🍃️🍃️ faces 🥺️☹️😂️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 42,
            selectedLength: 3,
            selectedText: "🍃️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 2,
                start: 18,
                end: 60
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 18)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}

