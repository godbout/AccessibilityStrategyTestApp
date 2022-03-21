@testable import AccessibilityStrategy
import XCTest


// same as b
// using TE function here that is tested heavily
class ASUT_NM_B__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.B(times: count, on: element) 
    }
    
}


// count
extension ASUT_NM_B__Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "we gonna move in-there with-count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: "u",
            visibleCharacterRange: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 3, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_stops_at_the_beginning_of_the_text_if_the_count_is_too_high() {
        let text = "😀️e gonna move in there with count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 44,
            caretLocation: 32,
            selectedLength: 1,
            selectedText: "u",
            visibleCharacterRange: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 44
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// emojis
extension ASUT_NM_B__Tests {
    
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
            caretLocation: 64,
            selectedLength: 1,
            selectedText: "t",
            visibleCharacterRange: 0..<84,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 84,
                number: 2,
                start: 34,
                end: 73
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.selectedLength, 3)
    }
    
}

