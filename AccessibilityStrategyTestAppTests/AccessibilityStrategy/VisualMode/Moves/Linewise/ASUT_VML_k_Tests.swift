import XCTest
import AccessibilityStrategy


class ASUT_VML_k_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.kForVisualStyleLinewise(on: element)
    }

}


// TextFields
// see j for bla blah


// see gj for blah blah
//
// TextViews
extension ASUT_VML_k_Tests {

    func test_that_if_the_head_is_before_the_anchor_then_it_extends_the_selection_by_one_line_above_at_a_time() {
        let text = """
so pressing k if the head
is before the anchor will
extend the selection to
the line above nice
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 95,
            caretLocation: 76,
            selectedLength: 19,
            selectedText: "the line above nice",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 95,
                number: 9,
                start: 76,
                end: 85
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 94
        AccessibilityStrategyVisualMode.head = 76
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 52)
        XCTAssertEqual(returnedElement.selectedLength, 43)
    }
    
    func test_that_if_the_head_is_after_the_anchor_then_it_reduces_the_selection_by_one_line_above_at_a_time() {
        let text = """
so pressing k if the head
is after the anchor will
reduce the selection to
the line above nice
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 94,
            caretLocation: 0,
            selectedLength: 94,
            selectedText: """
so pressing k if the head
is after the anchor will
reduce the selection to
the line above nice
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 94,
                number: 1,
                start: 0,
                end: 12
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 93
    
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 75)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_it_does_not_get_stuck_when_trying_to_move_up_and_selects_the_line_above() {
        let text = """
we gonna place the
caret at the last empty line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 48,
            caretLocation: 48,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 6,
                start: 48,
                end: 48
            )!
        )
        
        AccessibilityStrategyVisualMode.head = 48
        AccessibilityStrategyVisualMode.anchor = 48
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 29)
    }
    
}
