import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VML_v_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveAndGetBackAccessibilityElement() -> AccessibilityTextElement? {
        return applyMoveAndGetBackAccessibilityElement { focusedElement in
            asVisualMode.vForVisualStyleLinewise(on: focusedElement)
        }
    }
    
}


extension ASUI_VML_v_Tests {

    func test_that_if_we_were_already_in_VisualMode_Linewise_when_calling_v_it_sets_the_caret_and_anchor_to_the_end_limit_even_when_the_head_happened_to_be_after_the_end_limit() {
        let textInAXFocusedElement = """
entering with v from
VM linewise will set
the caret to the head
if the head is not after the line end limit
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [])

        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()

        XCTAssertEqual(accessibilityElement?.caretLocation, 62)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 62)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 62)
    }
    
    // TODO: review the one below

//    func test_that_the_caret_goes_to_the_head_location_after_having_being_switched_when_coming_from_Visual_Mode_linewise() {
//        let textInAXFocusedElement = "v after a V"
//        app.textFields.firstMatch.tap()
//        app.textFields.firstMatch.typeText(textInAXFocusedElement)
//        KindaVimEngine.shared.enterNormalMode()
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .V))
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .o))
//
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .v))
//        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
//
//        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
//    }

}


// emojis
// from what i've seen from the code, there's nothing that
// the emojis would affect
extension ASUI_VML_v_Tests {}
