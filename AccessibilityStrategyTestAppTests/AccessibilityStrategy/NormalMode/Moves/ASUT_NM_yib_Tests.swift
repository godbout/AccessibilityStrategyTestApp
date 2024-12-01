@testable import AccessibilityStrategy
import XCTest
import Common


// see `yiB` for blah blah
class ASUT_NM_yib_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState()
        
        return asNormalMode.yib(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_yib_Tests {

    func test_that_it_calls_yInnerBlock_with_the_correct_bracket_as_parameter() {
        let text = "some text that (😂️ has some nice ) braces"
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
