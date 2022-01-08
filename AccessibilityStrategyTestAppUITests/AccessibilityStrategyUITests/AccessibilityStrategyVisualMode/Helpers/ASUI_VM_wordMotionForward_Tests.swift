import XCTest
import AccessibilityStrategy
import VimEngineState


// other tests in Unit Tests. the UI is just to test special cases.
class ASUI_VM_wordMotionForward_Tests: ASUI_VM_BaseTests {

    var state = VimEngineState(visualStyle: .characterwise)
    
    
    func test_that_when_we_reach_the_anchor_and_will_reverse_anchor_and_head_the_move_does_not_block_and_moves_properly() {
        let textInAXFocusedElement = """
in Visual Mode Characterwise we
always move from the anchor, not
from the caret location
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.b(on: $0, state) }
        let accessibilityElement = applyMove { asVisualMode.w(on: $0, state) }

        XCTAssertEqual(accessibilityElement.caretLocation, 54)
        XCTAssertEqual(accessibilityElement.selectedLength, 6)
    }
    
    func test_that_the_head_is_getting_updated_properly() {
        let textInAXFocusedElement = "we-have to updated caretLocation before selectedLength!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
             
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.zero(on: $0, state) }
        applyMove { asVisualMode.E(on: $0, state) }

        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 6)
    }
    
}
