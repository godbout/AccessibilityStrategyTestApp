import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML_l_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .linewise)
        
        return asVisualMode.l(on: element, state)
    }
   
}


// nope
extension ASUT_VML_l_Tests {

    func test_that_this_move_does_not_exist_for_VisualModeStyle_Linewise() {
        let text = "       that's some nice text in here yehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 41,
            caretLocation: 17,
            selectedLength: 15,
            selectedText: "e nice text in ",
            fullyVisibleArea: 0..<41,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 41,
                number: 1,
                start: 0,
                end: 41
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 31
        AccessibilityStrategyVisualMode.head = 17
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 15)
        XCTAssertNil(returnedElement.selectedText)
    }

}
