@testable import AccessibilityStrategy
import XCTest
import Common


// moves in UI Tests.
class ASUT_NM_dd_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState ) -> AccessibilityTextElement {
        return asNormalMode.dd(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_dd_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_deletion_even_for_an_empty_line() {
        let text = """
if the next line is just blank characters
then there is no firstNonBlank so we need
          
to stop at the end limit of the line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 131,
            caretLocation: 77,
            selectedLength: 1,
            selectedText: """
        e
        """,
            fullyVisibleArea: 0..<131,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 131,
                number: 4,
                start: 59,
                end: 84
            )!
        )
        
        copyToClipboard(text: "nope you don't copy mofo")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "then there is no firstNonBlank so we need\n")
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}
