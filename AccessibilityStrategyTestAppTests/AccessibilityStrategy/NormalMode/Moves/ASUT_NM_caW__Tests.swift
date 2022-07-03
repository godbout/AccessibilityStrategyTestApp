@testable import AccessibilityStrategy
import XCTest
import Common


// see caWw
class ASUT_NM_caW__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return asNormalMode.caW(on: element, &state)
    }
    
}


extension ASUT_NM_caW__Tests {
    
    func test_that_we_pass_the_right_function_and_the_right_quote_to_the_helper_function() {
        let text = """
testing that we're sending
the right-parameter to the funcs!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 33,
            selectedLength: 1,
            selectedText: """
        g
        """,
            fullyVisibleArea: 0..<60,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 2,
                start: 27,
                end: 60
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 31)
        XCTAssertEqual(returnedElement.selectedLength, 16)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
