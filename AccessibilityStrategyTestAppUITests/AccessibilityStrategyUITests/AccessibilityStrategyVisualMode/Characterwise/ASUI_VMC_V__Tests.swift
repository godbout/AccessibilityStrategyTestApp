import XCTest
import AccessibilityStrategy


class ASUI_VMC_V__Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.VForVisualStyleCharacterwise(on: $0)}
    }

}


// TextAreas
extension ASUI_VMC_V__Tests {

    func test_that_if_we_were_in_VisualMode_Characterwise_when_calling_V_it_sets_the_anchor_and_caret_to_start_of_the_line_and_head_and_selection_to_end_of_line() {
        let textInAXFocusedElement = """
entering with V from
normal mode means anchor
and head are nil
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 46)
        XCTAssertEqual(accessibilityElement?.selectedLength, 16)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 46)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 61)
    }

}
