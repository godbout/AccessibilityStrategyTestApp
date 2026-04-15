import XCTest
@testable import AccessibilityStrategy
import Common


// see c$ for blah blah
class ASUT_NM_y$_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yDollarSign(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_y$_Tests {
    
    func test_that_a_FileLine_and_not_a_ScreenLine_is_sent_as_parameter_to_the_superman_move() {
        let text = "ok so now it's gonna be from caret to end limit"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 47,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: """
        w
        """,
            fullyVisibleArea: 0..<47,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 47,
                number: 1,
                start: 0,
                end: 24
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "w it's gonna be from caret to end limit")
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }
        
}
