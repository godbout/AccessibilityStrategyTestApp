@testable import AccessibilityStrategy
import XCTest
import Common


// see ya' for blah blah
class ASUT_NM_yiDoubleQuote_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        asNormalMode.yiDoubleQuote(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_yiDoubleQuote_Tests {
    
    func test_that_we_pass_the_right_function_and_the_right_quote_to_the_helper_function() {
        let text = """
ok so time to add
some new ("shit in there") right?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 51,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: """
        n
        """,
            fullyVisibleArea: 0..<51,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 2,
                start: 18,
                end: 51
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "shit in there")
        XCTAssertEqual(returnedElement.caretLocation, 29)  
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
