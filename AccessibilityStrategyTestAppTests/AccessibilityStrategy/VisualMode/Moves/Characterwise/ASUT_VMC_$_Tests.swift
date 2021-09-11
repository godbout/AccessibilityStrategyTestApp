@testable import AccessibilityStrategy
import XCTest


class ASUT_VMC_$_Tests: ASVM_BaseTests {
        
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.dollarSignForVisualStyleCharacterwise(on: element)
    }
    
}


// Both
extension ASUT_VMC_$_Tests {
    
    func test_that_it_sets_the_ATE_globalColumnNumber_to_nil() {
        let text = """
when using $
the globalColumnNumber
is set to nil so that next
j or k will go to the line endLimit
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 98,
            caretLocation: 52,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 3,
                start: 36,
                end: 63
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 52
        AccessibilityStrategyVisualMode.head = 52
        
        AccessibilityTextElement.globalColumnNumber = 17
       
        _ = applyMoveBeingTested(on: element)

        XCTAssertNil(AccessibilityTextElement.globalColumnNumber)
    }

}
