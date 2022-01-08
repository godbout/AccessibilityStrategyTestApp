import XCTest
import AccessibilityStrategy
import VimEngineState


class ASUI_VMC_g0_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asVisualMode.gZero(on: $0, state) }
    }
    
}


// Both
extension ASUI_VMC_g0_Tests {
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_to_the_beginning_of_the_line_and_extends_the_selection_backwards() {
        let textInAXFocusedElement = "that's some nice text in here yehe"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        let returnedElement = applyMoveBeingTested()

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 31)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_after_the_anchor_then_it_goes_to_beginning_of_the_line_by_reducing_the_selection_until_the_anchor_and_extending_it_from_the_anchor_to_the_beginning_of_the_line() {
        let textInAXFocusedElement = """
0 for visual mode starts
at the anchor, not at the caret location
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(on: $0, state) }

        let returnedElement = applyMoveBeingTested()
       
        XCTAssertEqual(returnedElement.caretLocation, 47)
        XCTAssertEqual(returnedElement.selectedLength, 5)
    }

}


// TextViews
extension ASUI_VMC_g0_Tests {

    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_before_the_anchor_the_it_goes_to_the_beginning_of_the_line_and_extends_the_selection() {
        let textInAXFocusedElement = """
⛱️e gonna select
over ⛱️⛱️ multiple lines coz
0 has some problems y
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.l(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.k(on: $0, state) }
        let returnedElement = applyMoveBeingTested()
       
        XCTAssertEqual(returnedElement.caretLocation, 36)
        XCTAssertEqual(returnedElement.selectedLength, 31)
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
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, state) }
        applyMove { asVisualMode.w(on: $0, state) }
        let returnedElement = applyMoveBeingTested()

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 36)
    }

}
