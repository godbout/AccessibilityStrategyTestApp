@testable import AccessibilityStrategy
import XCTest
import Common


// see iB for blah blah
class ASUT_VM_aLeftChevron_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState()
        
        return asVisualMode.aLeftChevron(on: element, &vimEngineState)
    }
    
}


extension ASUT_VM_aLeftChevron_Tests {

    func test_that_it_calls_the_helper_with_the_correct_block_as_parameter() {
        let text = "now th😄️at is < some stuff 😄️😄️😄️on the same > line😄️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 58,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<58,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 1,
                start: 0,
                end: 58
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 18
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 15)
        XCTAssertEqual(returnedElement.selectedLength, 35)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
