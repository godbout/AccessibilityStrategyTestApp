import XCTest
import KeyCombination
import AccessibilityStrategy


// see `V` for blah blah
class ASUI_VM_v_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { focusedElement in
            asVisualMode.vForEnteringFromNormalMode(on: focusedElement)
        }
    }
    
}


extension ASUI_VM_v_Tests {
    
    func test_that_if_we_just_entered_VisualMode_with_v_from_NormalMode_it_sets_the_anchor_and_head_to_the_caret_location() {
        let textInAXFocusedElement = """
entering with v from
normal mode 😀️eans anchor
and head are nil
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
           
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 33)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 33)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 33)
    }
    
    func test_that_if_we_just_entered_VisualMode_with_v_from_NormalMode_and_the_caret_location_is_over_the_line_end_limit_then_it_sets_the_caret_anchor_and_head_to_the_line_end_limit() {
        let textInAXFocusedElement = """
entering with v from
normal mode but with
caret out of boundaries
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
       
        XCTAssertEqual(accessibilityElement?.caretLocation, 40)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 40)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 40)
    }
    
    // only tested for vForEnteringFromNormalMode but done for all vs and Vs.
    // not tested because UI Tests are expensive, and it's a small thing. but adding this comment
    // because it's good to be reminded of it.
    func test_that_entering_VisualMode_with_v_from_NormalMode_does_not_override_the_globalColumnNumber() {
        let textInAXFocusedElement = """
if we $ before entering VM the GCN
should still stay at nil
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        _ = applyMoveBeingTested()
       
        XCTAssertNil(AccessibilityTextElement.globalColumnNumber)
    }

}
