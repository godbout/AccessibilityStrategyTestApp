@testable import AccessibilityStrategy
import XCTest
import Common


// calling yInnerBlock, all the tests are there.
// here we just have one test to check that we're calling yInnerBlock with the right bracket.
class ASUT_NM_yiB__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState()
        
        return asNormalMode.yiB(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_yiB__Tests {

    func test_that_it_calls_yInnerBlock_with_the_correct_bracket_as_parameter() {
        let text = "some text that {😂️ has some nice } braces"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: "m",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 16)  
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
