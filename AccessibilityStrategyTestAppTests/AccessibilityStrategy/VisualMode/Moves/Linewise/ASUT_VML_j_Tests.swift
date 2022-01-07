import XCTest
@testable import AccessibilityStrategy


class ASUT_VML_j_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.jForVisualStyleLinewise(on: element)
    }

}


// TextFields
// Alfred style stuff is handled and tested in kVE now


// TextViews
extension ASUT_VML_j_Tests {
    
    func test_that_if_the_head_is_after_the_anchor_then_it_extends_the_selection_by_one_line_below_at_a_time() {
        let text = """
so pressing j in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 0,
            selectedLength: 17,
            selectedText: "so pressing j in\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 1,
                start: 0,
                end: 12
            )!
        )
                
        AccessibilityStrategyVisualMode.head = 0
        AccessibilityStrategyVisualMode.anchor = 16
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 41)
    }
    
    func test_that_if_the_head_is_before_the_anchor_then_it_reduces_the_selection_by_one_line_below_at_a_time() {
        let text = """
so pressing j in
Visual Mode is gonna be
cool because it will reduce
the selection when the
head if before the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 117,
            caretLocation: 17,
            selectedLength: 100,
            selectedText: """
Visual Mode is gonna be
cool because it will reduce
the selection when the
head if before the anchor
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 117,
                number: 3,
                start: 17,
                end: 29
            )!
        )
        
        AccessibilityStrategyVisualMode.head = 17
        AccessibilityStrategyVisualMode.anchor = 116
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 76)
    }
    
    func test_that_it_does_not_skip_empty_lines() {
        let text = """
wow that one is

ass off lol
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 0,
            selectedLength: 16,
            selectedText: "wow that one is\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 1,
                start: 0,
                end: 13
            )!
        )
        
        AccessibilityStrategyVisualMode.head = 0
        AccessibilityStrategyVisualMode.anchor = 15
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 17)
    }
    
}
