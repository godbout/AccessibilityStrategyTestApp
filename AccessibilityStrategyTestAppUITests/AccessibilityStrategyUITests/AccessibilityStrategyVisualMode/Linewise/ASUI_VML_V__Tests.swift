import XCTest
import AccessibilityStrategy


class ASUI_VML_V__Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.VForVisualStyleLinewise(on: $0)}
    }

}


// TextAreas
extension ASUI_VML_V__Tests {
       
    func test_that_if_we_were_already_in_VisualMode_Linewise_when_calling_V_it_sets_the_caret_to_the_end_limit_even_when_the_head_happened_to_be_after_the_end_limit() {
        let textInAXFocusedElement = """
yeah we gonna
switch the head and the
anchor
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
       
        XCTAssertEqual(accessibilityElement?.caretLocation, 36)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }

    func test_that_the_caret_goes_to_the_head_location_after_having_being_switched_when_coming_from_Visual_Mode_linewise() {
        let textInAXFocusedElement = """
yeah we gonna
switch the head and the
anchor
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.o(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 14)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }

    func test_that_the_caret_goes_to_the_head_location_even_the_head_is_on_a_different_line_than_the_caret() {
        let textInAXFocusedElement = """
now we gonna have
the selection spread ove⛱️
multiple lines
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 42)
        XCTAssertEqual(accessibilityElement?.selectedLength, 2)
    }

}


// Anchor and Head
extension ASUI_VML_V__Tests {

    func test_that_it_resets_the_Anchor_and_Head_to_nil() {
        let textInAXFocusedElement = """
some bullshit again
really
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }

        XCTAssertNotNil(AccessibilityStrategyVisualMode.anchor)
        XCTAssertNotNil(AccessibilityStrategyVisualMode.head)
        
        _ = applyMoveBeingTested()
        
        XCTAssertNil(AccessibilityStrategyVisualMode.anchor)
        XCTAssertNil(AccessibilityStrategyVisualMode.head)
    }
        
}
