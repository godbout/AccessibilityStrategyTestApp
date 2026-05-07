import AccessibilityStrategy
import XCTest
import Common


class ASUT_VMC_is_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.is(on: element, vimEngineState)
    }
    
}


// TextFields and TextViews
extension ASUT_VMC_is_Tests {
    
    func test_that_if_the_Head_is_after_the_Anchor_it_extends_the_selection_to_the_end_of_the_inner_sentence_where_the_head_is() {
        let text = "brother. we're gonna need some sentences here. else it's not gonna work!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 72,
            caretLocation: 16,
            selectedLength: 8,
            selectedText: """
        onna nee
        """,
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 1,
                start: 0,
                end: 72
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 16
        AccessibilityStrategyVisualMode.head = 23
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertNil(returnedElement.selectedText)
    }

}
