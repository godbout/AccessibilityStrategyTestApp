import AccessibilityStrategy
import XCTest
import Common


// rest of tests in UI because this is a ScreenLine move!
class ASUT_VMC_g$_Tests: ASUT_VM_BaseTests {
        
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .characterwise)
                
        return asVisualMode.gDollarSign(on: element, state)
    }
    
}


// Both
extension ASUT_VMC_g$_Tests {
    
    func test_that_it_does_not_set_the_ATE_ColumnNumbers_to_nil() {
        let text = """
when using g$
the globalColumnNumber
is set to nil so that next
j or k will go to the line endLimit
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 99,
            caretLocation: 52,
            selectedLength: 1,
            selectedText: "o",
            visibleCharacterRange: 0..<99,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 99,
                number: 7,
                start: 47,
                end: 59
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 52
        AccessibilityStrategyVisualMode.head = 52
        
        AccessibilityTextElement.fileLineColumnNumber = 16
        AccessibilityTextElement.screenLineColumnNumber = 6
       
        _ = applyMoveBeingTested(on: element)

        XCTAssertNotNil(AccessibilityTextElement.fileLineColumnNumber)
        XCTAssertNotNil(AccessibilityTextElement.screenLineColumnNumber)
    }

}
