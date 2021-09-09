import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VML_k_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.kForVisualStyleLinewise(on: $0)}
    }

}


// TextFields
extension ASUI_VML_k_Tests {
    
    func test_that_in_TextFields_basically_it_does_nothing() {
        let textInAXFocusedElement = "hehe you little fucker"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 22)
    }
    
}


// TextViews
extension ASUI_VML_k_Tests {

    func test_that_if_the_head_is_before_the_anchor_then_it_extends_the_selection_by_one_line_above_at_a_time() {
        let textInAXFocusedElement = """
so pressing k if the head
is before the anchor will
extend the selection to
the line above nice
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
              
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 52)
        XCTAssertEqual(accessibilityElement?.selectedLength, 43)
       
        let finalAccessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(finalAccessibilityElement?.caretLocation, 26)
        XCTAssertEqual(finalAccessibilityElement?.selectedLength, 69)
    }
    
    func test_that_if_the_head_is_after_the_anchor_then_it_reduces_the_selection_by_one_line_above_at_a_time() {
        let textInAXFocusedElement = """
so pressing k if the head
is after the anchor will
reduce the selection to
the line above nice
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 75)
        
        let finalAccessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(finalAccessibilityElement?.caretLocation, 0)
        XCTAssertEqual(finalAccessibilityElement?.selectedLength, 51)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_it_does_not_get_stuck_when_trying_to_move_up_and_selects_the_line_above() {
        let textInAXFocusedElement = """
we gonna place the
caret at the last empty line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 19)
        XCTAssertEqual(accessibilityElement?.selectedLength, 29)
    }
    
}
