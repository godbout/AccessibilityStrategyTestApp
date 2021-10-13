import XCTest
import AccessibilityStrategy


class ASUI_VML_G__Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.GForVisualStyleLinewise(on: $0)}
    }

}


// Both
extension ASUI_VML_G__Tests {
    
    func test_that_if_the_TextElement_is_just_a_single_line_then_it_keeps_the_whole_line_selected() {
        let textInAXFocusedElement = "        so here we gonna test VG"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 32)
    }
    
}


// TextViews
extension ASUI_VML_G__Tests {
    
    func test_that_if_the_head_is_after_or_at_the_same_line_as_the_anchor_then_it_selects_from_the_anchor_to_the_end_of_the_text() {
        let textInAXFocusedElement = """
so now this is gonna
😂️ be a longer one
and we're gonna
select until
the end
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 21)
        XCTAssertEqual(accessibilityElement?.selectedLength, 56)
    }
    
    func test_that_if_the_head_is_before_the_line_of_the_anchor_then_it_selects_from_the_anchor_to_the_end_of_the_text() {
        let textInAXFocusedElement = """
so now this is gonna
😂️ be a longer one
and we're gonna
select until
the end
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.gkForVisualStyleLinewise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 41)
        XCTAssertEqual(accessibilityElement?.selectedLength, 36)
    }
    
}