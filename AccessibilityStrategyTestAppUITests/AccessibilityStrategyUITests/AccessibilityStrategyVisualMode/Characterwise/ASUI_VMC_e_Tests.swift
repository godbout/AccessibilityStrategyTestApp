import XCTest
import KeyCombination
import AccessibilityStrategy


// check b for blah blah blah
class UIASVMC_e_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0)}
    }

}


extension UIASVMC_e_Tests {
    
    func test_that_when_we_reach_the_anchor_and_will_reverse_anchor_and_head_the_e_move_does_not_block_and_moves_properly() {
        let textInAXFocusedElement = """
in Visual Mode Characterwise we
always move from the anchor, not
from the caret location
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 54)
        XCTAssertEqual(accessibilityElement?.selectedLength, 5)
    }
    
    func test_that_the_head_is_getting_updated_properly() {
        let textInAXFocusedElement = "we have to updated caretLocation before selectedLength!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
             
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.zeroForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 1)
    }
    
}
