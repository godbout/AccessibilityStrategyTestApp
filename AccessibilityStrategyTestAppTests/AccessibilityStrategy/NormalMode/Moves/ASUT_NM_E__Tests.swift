@testable import AccessibilityStrategy
import XCTest


// see b for blah blah
class ASUT_NM_E__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.E(times: count, on: element) 
    }
    
}


// count
extension ASUT_NM_E__Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "we gonna move in-there with-count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 11,
            selectedLength: 1,
            selectedText: "v",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 3, on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 32)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_it_stops_at_the_end_limit_if_the_count_goes_above_it() {
        let text = "we gonna move in-there with-count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "c",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 41)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
}


// emojis
extension ASUT_NM_E__Tests {
    
    func test_that_it_returns_the_correct_selectedLength() {
        let text = """
yeah coz the text functions don't
care about the length but 🦋️ the move
itself does
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 84,
            caretLocation: 58,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 84,
                number: 2,
                start: 34,
                end: 73
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.selectedLength, 3)
    }
    
}

