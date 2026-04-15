import XCTest
@testable import AccessibilityStrategy
import Common


class ASUT_NM_yCaret_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yCaret(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_yCaret_Tests {

    // there is a little something special here in the fact that we can't start a ScreenLine with Blanks lol
    // coz macOS doesn't allow that. if we try to add Blanks at the beginning of a ScreenLine macOS adds the
    // Blanks at the END OF THE PREVIOUS LINE instead. we can still test correctly the FileLine vs ScreenLine
    // here, but just fyi.
    func test_that_a_FileLine_and_not_a_ScreenLine_is_sent_as_parameter_to_the_superman_move() {
        let text = "    but are we gonna use y0 that much tho"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 41,
            caretLocation: 31,
            selectedLength: 1,
            selectedText: """
        t
        """,
            fullyVisibleArea: 0..<41,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 41,
                number: 2,
                start: 21,
                end: 41
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "but are we gonna use y0 tha")
        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }

}
