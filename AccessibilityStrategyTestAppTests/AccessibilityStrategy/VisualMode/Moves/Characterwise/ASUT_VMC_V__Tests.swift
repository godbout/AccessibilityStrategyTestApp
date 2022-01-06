import XCTest
import AccessibilityStrategy


class ASUT_VMC_V__Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.VForVisualStyleCharacterwise(on: element)
    }

}


// TextAreas
extension ASUT_VMC_V__Tests {

    func test_that_if_we_were_in_VisualMode_Characterwise_when_calling_V_it_sets_the_anchor_and_caret_to_start_of_the_line_and_head_and_selection_to_end_of_line() {
        let text = """
entering with V from
normal mode means anchor
and head are nil
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 62,
            caretLocation: 52,
            selectedLength: 6,
            selectedText: "ad are",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 62,
                number: 5,
                start: 46,
                end: 59
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 46)
        XCTAssertEqual(returnedElement.selectedLength, 16)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 46)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 61)
    }

}
