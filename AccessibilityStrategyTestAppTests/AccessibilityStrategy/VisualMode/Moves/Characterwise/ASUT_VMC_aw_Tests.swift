import AccessibilityStrategy
import XCTest
import Common


class ASUT_VMC_aw_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.aw(on: element, vimEngineState)
    }
    
}


// TextFields and TextViews
extension ASUT_VMC_aw_Tests {
    
    func test_that_if_the_Head_is_after_the_Anchor_it_extends_the_selection_to_the_end_of_the_aWord_where_the_Head_is() {
        let text = "the Head and the Anchor position are important to know in which way we extend the selection"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 91,
            caretLocation: 20,
            selectedLength: 20,
            selectedText: "hor position are imp",
            fullyVisibleArea: 0..<91,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 91,
                number: 1,
                start: 0,
                end: 55
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 20
        AccessibilityStrategyVisualMode.head = 39
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
