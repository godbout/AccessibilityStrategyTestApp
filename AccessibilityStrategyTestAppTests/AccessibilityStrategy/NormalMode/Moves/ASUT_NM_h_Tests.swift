@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_h_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.h(on: element) 
    }
    
}


// line
extension ASUT_NM_h_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen 🇫🇷️ines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 119,
            caretLocation: 39,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 2,
                start: 39,
                end: 66
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 34)
        XCTAssertEqual(returnedElement.selectedLength, 5)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// Both
extension ASUT_NM_h_Tests {
    
    func test_that_in_normal_setting_on_a_file_line_it_goes_one_character_to_the_left() {
        let text = "h goes one character to the left yes but of not course not at 💣️he beginning but it's fine here"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 96,
            caretLocation: 62,
            selectedLength: 3,
            selectedText: "💣️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 96,
                number: 2,
                start: 37,
                end: 68
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 61)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
        
    func test_that_on_a_file_line_it_does_not_move_once_it_reaches_the_beginning_of_the_line() {
        let text = """
like yeah it's totally true once you've reach the start of the file line you're
definitely not going to go more up my friend
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 125,
            caretLocation: 80,
            selectedLength: 1,
            selectedText: "d",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 125,
                number: 4,
                start: 80,
                end: 115
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 80)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }    
    
}
