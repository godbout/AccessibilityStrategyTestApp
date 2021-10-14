import XCTest
import AccessibilityStrategy


class ASUI_VML_gj_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.gjForVisualStyleLinewise(on: $0)}
    }

}


// TextFields
extension ASUI_VML_gj_Tests {
    
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

// TODO: this is plain wrong. gj and gk can't actually be done like Vim. need to think.
// currently i think we should handle them like j and k
//
//// TextViews
//extension ASUI_VML_gj_Tests {
//    
//    // we go down twice coz once worked but twice didn't hehe :))
//    func test_that_if_the_head_is_after_the_anchor_then_it_extends_the_selection_by_one_line_below_at_a_time() {
//        let textInAXFocusedElement = """
//so pressing j in
//Visual Mode is gonna be
//cool because it will extend
//the selection
//when the head is after the anchor
//"""
//        app.textViews.firstMatch.tap()
//        app.textViews.firstMatch.typeText(textInAXFocusedElement)
//       
//        applyMove { asNormalMode.gg(on: $0) }
//        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
//
//        let accessibilityElement = applyMoveBeingTested()
//
//        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
//        XCTAssertEqual(accessibilityElement?.selectedLength, 41)
//        
//        let finalAccessibilityElementHehe = applyMoveBeingTested()
//       
//        XCTAssertEqual(finalAccessibilityElementHehe?.caretLocation, 0)
//        XCTAssertEqual(finalAccessibilityElementHehe?.selectedLength, 69)
//    }
//    
//    func test_that_if_the_head_is_before_the_anchor_then_it_reduces_the_selection_by_one_line_below_at_a_time() {
//        let textInAXFocusedElement = """
//so pressing j in
//Visual Mode is gonna be
//cool because it will reduce
//the selection when the
//head if before the anchor
//"""
//        app.textViews.firstMatch.tap()
//        app.textViews.firstMatch.typeText(textInAXFocusedElement)
//               
//        applyMove { asNormalMode.h(on: $0) }
//        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
//        applyMove { asVisualMode.gkForVisualStyleLinewise(on: $0) }
//        applyMove { asVisualMode.gkForVisualStyleLinewise(on: $0) }
//        applyMove { asVisualMode.gkForVisualStyleLinewise(on: $0) }
//        let accessibilityElement = applyMoveBeingTested()
//
//        XCTAssertEqual(accessibilityElement?.caretLocation, 41)
//        XCTAssertEqual(accessibilityElement?.selectedLength, 76)
//        
//        let finalAccessibilityElementHehe = applyMoveBeingTested()
//        
//        XCTAssertEqual(finalAccessibilityElementHehe?.caretLocation, 69)
//        XCTAssertEqual(finalAccessibilityElementHehe?.selectedLength, 48)
//    }
//    
//    func test_that_it_does_not_skip_empty_lines() {
//        let textInAXFocusedElement = """
//wow that one is
//
//ass off lol
//"""
//        app.textViews.firstMatch.tap()
//        app.textViews.firstMatch.typeText(textInAXFocusedElement)
//        
//        applyMove { asNormalMode.h(on: $0) }
//        applyMove { asNormalMode.gg(on: $0) }
//        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
//        let accessibilityElement = applyMoveBeingTested()
//
//        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
//        XCTAssertEqual(accessibilityElement?.selectedLength, 17)
//    }
//    
//}
