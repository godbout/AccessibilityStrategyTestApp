import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VML_V__Tests: ASUI_VM_BaseTests {}


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
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.VForVisualStyleLinewise(on: $0) }
       
        XCTAssertEqual(accessibilityElement?.caretLocation, 14)
    }

    func test_that_the_caret_goes_to_the_head_location_after_having_being_switched_when_coming_from_Visual_Mode_linewise() {
        let textInAXFocusedElement = """
yeah we gonna
switch the head and the
anchor
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [])
        
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.o(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.VForVisualStyleLinewise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 14)
    }

    // TODO: review. this is failing because the last move cannot be pushed to FocusedElement
    // the reason is because the selectedLength is too big
    // and currently this is because we don't handle the selectedLengh in that case in the move
    // itself, but in KVE. there's several cases of those. may need to move the separation of concerns?
    func test_that_the_caret_goes_to_the_head_location_even_the_head_is_on_a_different_line_than_the_caret() {
        let textInAXFocusedElement = """
now we gonna have
the selection spread over
multiple lines
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.VForVisualStyleLinewise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 42)
    }

}


// emojis
// same as VM v. from what i saw from the code, nothing the emojis would affect
extension ASUI_VML_V__Tests {}
