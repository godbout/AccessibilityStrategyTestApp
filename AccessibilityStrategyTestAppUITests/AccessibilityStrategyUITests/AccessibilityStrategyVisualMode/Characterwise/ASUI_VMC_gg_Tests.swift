import XCTest
import AccessibilityStrategy


class ASUI_VMC_gg_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.ggForVisualStyleCharacterwise(on: $0)}
    }
   
}


// Both
extension ASUI_VMC_gg_Tests {
    
    // see G for blah blah!
    func test_that_if_the_new_head_location_is_after_the_anchor_then_it_selects_from_the_anchor_to_the_new_head_location() {
        let textInAXFocusedElement = "        so here we gonna test vgg"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 1)
        XCTAssertEqual(accessibilityElement?.selectedLength, 8)
    }
    
}


// TextViews
extension ASUI_VMC_gg_Tests {

    func test_that_if_the_new_head_location_is_before_the_anchor_then_it_selects_from_anchor_to_the_new_head_location() {
        let textInAXFocusedElement = """
    ⛱️e gonna put the caret
way after the new head location
and it's gonna run smooooooooooooth
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
              
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 4)
        XCTAssertEqual(accessibilityElement?.selectedLength, 43)
    }
    
}
