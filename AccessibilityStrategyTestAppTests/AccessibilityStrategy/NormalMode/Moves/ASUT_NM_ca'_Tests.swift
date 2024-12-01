@testable import AccessibilityStrategy
import XCTest
import Common


// this is calling cQuotedString, all tests are there.
// here we just test that we're passing the right parameters to cQuotedString.
class ASUT_NM_caSingleQuote_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return asNormalMode.caSingleQuote(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_caSingleQuote_Tests {
    
    func test_that_we_pass_the_right_function_and_the_right_quote_to_the_helper_function() {
        let text = """
deliberately multiline
because 'it gonna' crash 😅️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 51,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: """
        s
        """,
            fullyVisibleArea: 0..<51,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 2,
                start: 23,
                end: 51
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 31)
        XCTAssertEqual(returnedElement.selectedLength, 11)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
