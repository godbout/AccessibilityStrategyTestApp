import XCTest
import AccessibilityStrategy


class ASUT_VML_v_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.vForVisualStyleLinewise(on: element)
    }

}


extension ASUT_VML_v_Tests {

    func test_that_if_we_were_already_in_VisualMode_Linewise_when_calling_v_it_sets_the_caret_and_anchor_to_the_end_limit_even_when_the_head_happened_to_be_after_the_end_limit() {
        let text = """
entering with v from
VM linewise will set
the caret to the head
if the head is not after the line end limit
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 107,
            caretLocation: 42,
            selectedLength: 22,
            selectedText: "the caret to the head\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 107,
                number: 5,
                start: 42,
                end: 55
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 42
        AccessibilityStrategyVisualMode.head = 63

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 62)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 62)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 62)
    }
    
    func test_that_the_caret_goes_to_the_head_location_after_having_being_switched_when_coming_from_Visual_Mode_linewise() {
        let text = "⛱️ v after a V"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 14,
            caretLocation: 0,
            selectedLength: 14,
            selectedText: "⛱️ v after a V",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 14,
                number: 1,
                start: 0,
                end: 14
            )!
        )

        AccessibilityStrategyVisualMode.anchor = 13
        AccessibilityStrategyVisualMode.head = 0

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 2)
    }

}
