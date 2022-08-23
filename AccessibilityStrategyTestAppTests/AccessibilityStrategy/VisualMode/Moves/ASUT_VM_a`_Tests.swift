@testable import AccessibilityStrategy
import XCTest
import Common


// see VM i" for blah blah
class ASUT_VM_aBacktickQuote_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState()
        
        return asVisualMode.aBacktick(on: element, &state)
    }
    
}


extension ASUT_VM_aBacktickQuote_Tests {

    func test_that_it_calls_the_helper_with_the_correct_quotedString_func_and_quoteType_as_parameters() {
        let text = """
now th😄️at is ` some stuff 😄️😄️😄️on the same ` line😄️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 58,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: """
        o
        """,
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
        XCTAssertEqual(returnedElement.selectedLength, 36)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
