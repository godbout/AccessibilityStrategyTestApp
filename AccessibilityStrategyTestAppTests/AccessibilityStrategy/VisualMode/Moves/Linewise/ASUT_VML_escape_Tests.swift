import XCTest
import AccessibilityStrategy


// see the other VM escape for explanation
class ASUT_VML_escape_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.escape(on: element)
    }

}


// TextFields
extension ASUT_VML_escape_Tests {
    
    func test_that_the_caret_location_goes_to_the_head() {
        let text = "some plain simple text for once"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 31,
            caretLocation: 0,
            selectedLength: 31,
            selectedText: "some plain simple text for once",
            visibleCharacterRange: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 1,
                start: 0,
                end: 31
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 30
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}


// TextViews
extension ASUT_VML_escape_Tests {
    
    func test_that_the_caret_location_goes_to_the_head_even_when_the_selection_spans_over_multiple_lines() {
        let text = """
⛱️et's try with selecting
over multiple lines
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 45,
            caretLocation: 0,
            selectedLength: 45,
            selectedText: "⛱️et's try with selecting\nover multiple lines",
            visibleCharacterRange: 0..<45,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 45,
                number: 1,
                start: 0,
                end: 11
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 44
        AccessibilityStrategyVisualMode.head = 0
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 2)

    }
    
    func test_that_if_the_head_is_above_line_end_limit_then_the_caret_goes_to_the_end_limit() {
        let text = """
so this is definitely
gonna go after
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 0,
            selectedLength: 36,
            selectedText: "so this is definitely\ngonna go after",
            visibleCharacterRange: 0..<36,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 1,
                start: 0,
                end: 11
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 35

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 35)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}
