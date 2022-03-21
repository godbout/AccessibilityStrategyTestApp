import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_0_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.zero(on: element, state)
    }
   
}


// Both
extension ASUT_VMC_0_Tests {
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_to_the_beginning_of_the_line_and_extends_the_selection_backwards() {
        let text = "that's some nice text in here yehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 34,
            caretLocation: 25,
            selectedLength: 6,
            selectedText: "here y",
            visibleCharacterRange: 0..<34,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 30
        AccessibilityStrategyVisualMode.head = 25
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 31)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_after_the_anchor_then_it_goes_to_beginning_of_the_line_by_reducing_the_selection_until_the_anchor_and_extending_it_from_the_anchor_to_the_beginning_of_the_line() {
        let text = """
0 for visual mode starts
at the anchor, not at the caret location
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 65,
            caretLocation: 51,
            selectedLength: 5,
            selectedText: "caret",
            visibleCharacterRange: 0..<65,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 65,
                number: 5,
                start: 44,
                end: 57
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 51
        AccessibilityStrategyVisualMode.head = 55

        let returnedElement = applyMoveBeingTested(on: element)
       
        XCTAssertEqual(returnedElement.caretLocation, 25)
        XCTAssertEqual(returnedElement.selectedLength, 27)
    }

}


// TextViews
extension ASUT_VMC_0_Tests {

    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_before_the_anchor_the_it_goes_to_the_beginning_of_the_line_and_extends_the_selection() {
        let text = """
⛱️e gonna select
over ⛱️⛱️ multiple lines coz
0 has some problems y
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 67,
            caretLocation: 10,
            selectedLength: 28,
            selectedText: "select\nover ⛱️⛱️ multiple li",
            visibleCharacterRange: 0..<67,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 67,
                number: 2,
                start: 10,
                end: 17
            )!
        )
        
        
        AccessibilityStrategyVisualMode.anchor = 37
        AccessibilityStrategyVisualMode.head = 10

        let returnedElement = applyMoveBeingTested(on: element)
       
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 38)
    }
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_after_the_anchor_then_it_goes_to_the_beginning_of_the_line_and_reduces_the_selection() {
        let text = """
we gonna select from top to bottom
over multiple lines and send 0 on
a line and the caret should to the
start of the line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 121,
            caretLocation: 0,
            selectedLength: 39,
            selectedText: "we gonna select from top to bottom\nover",
            visibleCharacterRange: 0..<121,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 121,
                number: 1,
                start: 0,
                end: 9
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 38

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 36)
    }

}

