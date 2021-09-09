import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VMC_0_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.zeroForVisualStyleCharacterwise(on: $0)}
    }
   
}


// Both
extension ASUI_VMC_0_Tests {
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_to_the_beginning_of_the_line_and_extends_the_selection_backwards() {
        let textInAXFocusedElement = "that's some nice text in here yehe"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 31)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_after_the_anchor_then_it_goes_to_beginning_of_the_line_by_reducing_the_selection_until_the_anchor_and_extending_it_from_the_anchor_to_the_beginning_of_the_line() {
        let textInAXFocusedElement = """
0 for visual mode starts
at the anchor, not at the caret location
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
       
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 27)
    }

}


// TextViews
extension ASUI_VMC_0_Tests {

    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_before_the_anchor_the_it_goes_to_the_beginning_of_the_line_and_extends_the_selection() {
        let textInAXFocusedElement = """
⛱️e gonna select
over ⛱️⛱️ multiple lines coz
0 has some problems y
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.zeroForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
       
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 38)
    }
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_after_the_anchor_then_it_goes_to_the_beginning_of_the_line_and_reduces_the_selection() {
        let textInAXFocusedElement = """
we gonna select from top to bottom
over multiple lines and send 0 on
a line and the caret should to the
start of the line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 36)
    }

}
