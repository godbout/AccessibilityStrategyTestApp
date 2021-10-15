@testable import AccessibilityStrategy
import XCTest


class ASUT_VMC_g$_Tests: ASVM_BaseTests {
        
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.gDollarSignForVisualStyleCharacterwise(on: element)
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

        XCTAssertNil(AccessibilityTextElement.screenLineColumnNumber)
    }

}
