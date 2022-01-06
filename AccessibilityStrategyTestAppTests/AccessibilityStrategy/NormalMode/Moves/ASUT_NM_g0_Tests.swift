@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_g0_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.gZero(on: element) 
    }
    
}


// line
extension ASUT_NM_g0_Tests {
    func test_conspicuously_that_it_stops_at_screen_lines() {
        let text = """
this move stops at screen lines, which means it will
stop even without a linefeed. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 108,
            caretLocation: 48,
            selectedLength: 1,
            selectedText: "w",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 108,
                number: 2,
                start: 33,
                end: 53
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// Both
extension ASUT_NM_g0_Tests {

    func test_that_in_normal_setting_it_moves_the_caret_position_to_the_first_character_of_the_line() {
        let text = "g0 should send us to the beginning of the screen line"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 53,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 53,
                number: 1,
                start: 0,
                end: 35
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }    

}

// TextViews
extension ASUT_NM_g0_Tests {

    func test_that_at_the_beginning_of_a_line_zero_does_not_move() {
        let text = """
multiline
where we gonna test g0
and again this is for screen lines 😀️y friend so this line is long!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 101,
            caretLocation: 87,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 101,
                number: 4,
                start: 68,
                end: 101
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 68)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }

}
