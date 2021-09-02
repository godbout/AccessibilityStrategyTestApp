import XCTest
import KeyCombination
import AccessibilityStrategy


// this is `V` when entering from NM
class ASUI_VM_V__Tests: ASUI_VM_BaseTests {
    
    private func applyMoveAndGetBackAccessibilityElement() -> AccessibilityTextElement? {
        return applyMoveAndGetBackAccessibilityElement { focusedElement in
            asVisualMode.VForEnteringFromNormalMode(on: focusedElement)
        }
    }
}


// Both
extension ASUI_VM_V__Tests {
    
    func test_that_it_selects_the_whole_line_even_if_it_does_not_end_with_a_linefeed() {
        let textInAXFocusedElement = "a sentence without a linefeed"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [])
       
        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()
        
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 28)
    }
    
}


// TextAreas
extension ASUI_VM_V__Tests {
       
    func test_that_if_we_just_entered_VisualMode_with_V_from_NormalMode_it_sets_the_anchor_and_caret_to_start_of_the_line_and_head_and_selection_to_end_of_line() {
        let textInAXFocusedElement = """
now that's one with
a linefeed at the end
!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [])
       
        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()

        XCTAssertEqual(accessibilityElement?.caretLocation, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 41)
    }
   
}


// emojis
// same as VM v. from what i saw from the code, nothing the emojis would affect
extension ASUI_VM_V__Tests {}
