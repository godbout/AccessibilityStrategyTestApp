import XCTest
import AccessibilityStrategy


class ASUI_VML_v_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.vForVisualStyleLinewise(on: $0)}
    }

}


extension ASUI_VML_v_Tests {

    func test_that_if_we_were_already_in_VisualMode_Linewise_when_calling_v_it_sets_the_caret_and_anchor_to_the_end_limit_even_when_the_head_happened_to_be_after_the_end_limit() {
        let textInAXFocusedElement = """
entering with v from
VM linewise will set
the caret to the head
if the head is not after the line end limit
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 62)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 62)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 62)
    }
    
    func test_that_the_caret_goes_to_the_head_location_after_having_being_switched_when_coming_from_Visual_Mode_linewise() {
        let textInAXFocusedElement = "⛱️ v after a V"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.o(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 2)
    }

}
