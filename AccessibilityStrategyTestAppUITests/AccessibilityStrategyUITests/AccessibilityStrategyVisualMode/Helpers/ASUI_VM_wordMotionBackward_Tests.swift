import XCTest
@testable import AccessibilityStrategy
import Common


// see wordMotionForward for blah blah
class ASUI_VM_wordMotion_backward_Tests: ASUI_VM_BaseTests {

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
        applyMove { asVisualMode.e(on: $0, state) }
        let accessibilityElement = applyMove { asVisualMode.b(on: $0, state) }

        XCTAssertEqual(accessibilityElement.caretLocation, 53)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
    func test_that_the_head_is_getting_updated_properly() {
        let textInAXFocusedElement = "we have to updated caretLocation before-selectedLength!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.B(on: $0, state) }
        // it used to fail after the second move
        applyMove { asVisualMode.B(on: $0, state) }

        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 19)
    }
    
}
