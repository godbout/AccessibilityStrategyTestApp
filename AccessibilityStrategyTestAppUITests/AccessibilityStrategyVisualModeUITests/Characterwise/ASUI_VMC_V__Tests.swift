import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VMC_V__Tests: ASUI_VM_BaseTests {
    
    private func applyMoveAndGetBackAccessibilityElement() -> AccessibilityTextElement? {
        return applyMoveAndGetBackAccessibilityElement { focusedElement in
            asVisualMode.VForVisualStyleCharacterwise(on: focusedElement)
        }
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
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [])

        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()

        XCTAssertEqual(accessibilityElement?.caretLocation, 46)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 46)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 61)
    }

}


// emojis
// same as VM v. from what i saw from the code, nothing the emojis would affect
extension ASUI_VMC_V__Tests {}
