@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_h_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.h(on: element) 
    }
    
}


// Both
extension ASUT_NM_h_Tests {
    
    func test_that_in_normal_setting_h_goes_one_character_to_the_left() {
        let text = "h goes one character to the left"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 16,
            selectedLength: 1,
            selectedText: "c",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 1,
                start: 0,
                end: 32
            )
        )

        let returnedElement = applyMove(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 15)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
        
    func test_that_at_the_beginning_of_a_Text_AXUIElement_h_does_not_move() {
        let text = """
if at beginning of a Text AXUIElement
h should not move
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 55,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: "i",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 1,
                start: 0,
                end: 38
            )
        )

        let returnedElement = applyMove(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }    
    
}


// TextAreas
extension ASUT_NM_h_Tests {

    func test_that_at_the_beginning_of_a_line_h_does_not_move_up_to_the_prevous_line_in_TextAreas() {
        let text = """
in multiline if
at the beginning of a line
h should not go up to
the previous line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 82,
            caretLocation: 43,
            selectedLength: 1,
            selectedText: "h",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 3,
                start: 43,
                end: 65
            )
        )

        let returnedElement = applyMove(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 43)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }

}


// emojis
extension ASUT_NM_h_Tests {
    
    func test_that_it_stops_at_emojis_properly_like_an_adult() {
        let text = """
gonna blow up
that shit 💣️ again
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 33,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 2,
                start: 14,
                end: 33
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 24)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_it_can_pass_and_does_not_get_stuck_at_emojis() {
        let text = """
gonna blow up
that shit 💣️ again
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 33,
            caretLocation: 24,
            selectedLength: 3,
            selectedText: "💣️",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 2,
                start: 14,
                end: 33
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 23)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
