import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_G__Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.G(on: element, state)
    }

}


// Both
extension ASUT_VMC_G__Tests {

    // this only happens if the new head location and the anchor are on the same line!
    func test_that_if_the_new_head_location_is_before_the_anchor_then_it_selects_from_the_new_head_location_until_the_anchor() {
        let text = "        💩️o here we 💩️ gonna test vG"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 38,
            caretLocation: 31,
            selectedLength: 6,
            selectedText: "test v",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 1,
                start: 0,
                end: 38
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 36
        AccessibilityStrategyVisualMode.head = 31

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 29)
    }

}


// TextViews
extension ASUT_VMC_G__Tests {
    
    func test_that_if_the_new_head_location_is_after_the_anchor_then_it_selects_from_anchor_to_the_new_head_location() {
        let text = """
we gonna put the caret before
the anchor and do
the move and it should
     all work fine
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 89,
            caretLocation: 17,
            selectedLength: 30,
            selectedText: "caret before\nthe anchor and do",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 89,
                number: 2,
                start: 13,
                end: 23
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 46
        AccessibilityStrategyVisualMode.head = 17

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 46)
        XCTAssertEqual(returnedElement.selectedLength, 31)
    }
    
}
