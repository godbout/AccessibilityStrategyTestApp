import XCTest
import AccessibilityStrategy
import Common


class ASUI_VMC_g$_Tests: ASUI_VM_BaseTests {

    var state = VimEngineState(visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asVisualMode.gDollarSign(on: $0, state) }
    }
    
}


// Both
extension ASUI_VMC_g$_Tests {
            
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_after_the_anchor_then_it_goes_to_the_end_of_the_line_and_extends_the_selection() {
        let textInAXFocusedElement = "hello world"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 5)
        XCTAssertEqual(accessibilityElement.selectedLength, 6)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_to_the_end_of_the_line_and_reduces_the_selection_until_the_anchor_and_then_extends_it_after() {
        let textInAXFocusedElement = """
g$ for visual mode starts
at the anchor, not at the caret location
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.b(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 58)
        XCTAssertEqual(accessibilityElement.selectedLength, 8)
    }
    
}


// TextViews
extension ASUI_VMC_g$_Tests {
    
    func test_that_if_line_ends_with_linefeed_it_goes_to_the_end_of_the_line_still() {
        let textInAXFocusedElement = """
indeed
that is
multiline
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
                
        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_after_the_anchor_then_it_goes_to_the_end_of_the_line_where_the_head_is_located_and_extends_the_selection() {
        let textInAXFocusedElement = """
we gonna select
over multiple lines coz
g$ not work ⛱️⛱️LOOOL
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(on: $0, state) }
        applyMove { asVisualMode.e(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 36)
        XCTAssertEqual(accessibilityElement.selectedLength, 25)
    }

    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_before_the_anchor_then_it_goes_to_the_end_of_the_line_where_the_head_is_located_and_reduces_the_selection() {
        let textInAXFocusedElement = """
we gonna select
over multiple lines coz
g$ doesn't work LOOOLL
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.b(on: $0, state) }
        applyMove { asVisualMode.gk(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 39)
        XCTAssertEqual(accessibilityElement.selectedLength, 23)
    }
    
}
