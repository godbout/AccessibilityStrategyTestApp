@testable import AccessibilityStrategy
import XCTest
import Common


// currently we test VM i"/a" and co. here because we consider Characterwise
// and Linewise moves to be the same, but in Vim reality they're not. the VM i"/a" and co.
// moves are WAY MORE COMPLICATED than this. you can enter VM Linewise and sometimes
// i" will work, sometimes it will Bip, depending on where you enter VM Linewise, and
// if you moved the caret, and in which direction etc etc. 
// currently we have a simplified version. hopefully covers 80% of the cases.
// the rest seems a nightmare to do. also probably need to move to regex.
class ASUT_VM_iDoubleQuote_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState()
        
        return asVisualMode.iDoubleQuote(on: element, &state)
    }
    
}


extension ASUT_VM_iDoubleQuote_Tests {

    func test_that_it_calls_the_helper_with_the_correct_quotedString_func_and_quoteType_as_parameters() {
        let text = """
now th😄️at is " some stuff 😄️😄️😄️on the same " line😄️
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
        
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 33)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 16)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 48)
    }
    
}
