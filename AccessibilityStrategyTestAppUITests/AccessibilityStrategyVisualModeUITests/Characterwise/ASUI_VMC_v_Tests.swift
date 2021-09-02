import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VMC_v_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveAndGetBackAccessibilityElement() -> AccessibilityTextElement? {
        return applyMoveAndGetBackAccessibilityElement { focusedElement in
            asVisualMode.vForVisualStyleCharacterwise(on: focusedElement)
        }
    }
    
}


extension ASUI_VMC_v_Tests {

    // TODO: review the two below
//    func test_that_if_we_were_already_in_VisualMode_Characterwise_when_calling_v_it_sets_the_caret_to_the_head_location_that_will_never_be_behind_the_end_limit() {
//        let textInAXFocusedElement = """
//entering with v from
//VM linewise will set
//the caret to the head
//if the head is not after the line end limit
//"""
//        app.textViews.firstMatch.tap()
//        app.textViews.firstMatch.typeText(textInAXFocusedElement)
//        KindaVimEngine.shared.enterNormalMode()
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .k))
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .zero))
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .v))
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .e))
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .e))
//
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .v))
//        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
//
//        XCTAssertEqual(accessibilityElement?.caretLocation, 50)
//    }
//
//    func test_that_the_caret_goes_to_the_head_location_even_the_head_is_on_a_different_line_than_the_caret() {
//        let textInAXFocusedElement = """
//now we gonna have
//the selection spread over
//multiple lines
//"""
//        app.textViews.firstMatch.tap()
//        app.textViews.firstMatch.typeText(textInAXFocusedElement)
//        KindaVimEngine.shared.enterNormalMode()
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .k))
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .k))
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .v))
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .dollarSign))
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(vimKey: .e))
//
//        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .v))
//        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
//
//        XCTAssertEqual(accessibilityElement?.caretLocation, 20)
//    }

}


// emojis
// from what i've seen from the code, there's nothing that
// the emojis would affect
extension ASUI_VMC_v_Tests {}
