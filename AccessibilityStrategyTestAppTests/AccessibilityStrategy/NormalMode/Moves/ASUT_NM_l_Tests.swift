@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_l_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.l(times: count, on: element) 
    }
    
}


// line
extension ASUT_NM_l_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen 🇫🇷️ines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 119,
            caretLocation: 34,
            selectedLength: 5,
            selectedText: "🇫🇷️",
            fullyVisibleArea: 0..<119,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 1,
                start: 0,
                end: 39
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 39)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_NM_l_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "we gonna move in there with count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "c",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 8, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 38)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_stops_at_the_end_limit_if_the_count_goes_above_it() {
        let text = "we gonna move in there with count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "c",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
}


// Both
extension ASUT_NM_l_Tests {
    
    func test_that_in_normal_setting_on_a_file_line_it_goes_one_character_to_the_right() {
        let text = "l should go one chara💣️er to the right and it's already pretty good!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 68,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<68,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 68,
                number: 1,
                start: 0,
                end: 68
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 21)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_on_a_file_line_it_does_not_move_once_it_reaches_the_line_end_limit() {
        let text = """
hehe yes if you're at the end of a fucking line my boy you shouldn't go foward more or you gonna fall.
dumbass.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 111,
            caretLocation: 101,
            selectedLength: 1,
            selectedText: ".",
            fullyVisibleArea: 0..<111,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 111,
                number: 4,
                start: 91,
                end: 103
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 101)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
