import XCTest
import KeyCombination
import AccessibilityStrategy


// the 3 cases are already done in Unit Tests. the UI for b is just to test a special case
class UIASVMC_b_Tests: ASUI_VM_BaseTests {}


extension UIASVMC_b_Tests {

    func test_that_when_we_reach_the_anchor_and_will_reverse_anchor_and_head_the_b_move_does_not_block_and_moves_properly() {
        let textInAXFocusedElement = """
in Visual Mode Characterwise we
always move from the anchor, not
from the caret location
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 53)
        XCTAssertEqual(accessibilityElement?.selectedLength, 2)
    }
    
    func test_that_the_head_is_getting_updated_properly() {
        let textInAXFocusedElement = "we have to updated caretLocation before selectedLength!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        // it used to fail after the second move
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 33)
    }
    
}
