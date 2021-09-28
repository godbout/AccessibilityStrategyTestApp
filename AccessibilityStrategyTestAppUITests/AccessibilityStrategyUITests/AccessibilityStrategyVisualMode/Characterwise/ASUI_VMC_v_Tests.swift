import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VMC_v_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.vForVisualStyleCharacterwise(on: $0)}
    }

}


extension ASUI_VMC_v_Tests {

    func test_that_if_we_were_already_in_VisualMode_Characterwise_when_calling_v_it_sets_the_caret_to_the_head_location_that_will_never_be_behind_the_end_limit() {
        let textInAXFocusedElement = """
entering with v from
VM linewise will set
the caret to the head
if the head is not after the line end limit
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 50)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }

    func test_that_the_caret_goes_to_the_head_location_even_the_head_is_on_a_different_line_than_the_caret() {
        let textInAXFocusedElement = """
now we gonna have
the⛱️ selection spread over
multiple lines
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.gDollarSignForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 21)
        XCTAssertEqual(accessibilityElement?.selectedLength, 2)
    }
    
}


// Anchor and Head
extension ASUI_VMC_v_Tests {

    func test_that_it_resets_the_Anchor_and_Head_to_nil() {
        let textInAXFocusedElement = "some bullshit really"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        
        XCTAssertNotNil(AccessibilityStrategyVisualMode.anchor)
        XCTAssertNotNil(AccessibilityStrategyVisualMode.head)
        
        _ = applyMoveBeingTested()
        
        XCTAssertNil(AccessibilityStrategyVisualMode.anchor)
        XCTAssertNil(AccessibilityStrategyVisualMode.head)
    }
        
}
