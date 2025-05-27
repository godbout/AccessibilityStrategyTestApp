@testable import AccessibilityStrategy
import XCTest
import Common


// moves in UI Tests.
class ASUT_NM_dd_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, appFamily: AppFamily) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        asNormalMode.dd(on: element, &vimEngineState)
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
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "then there is no firstNonBlank so we need\n")
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
}


// specific bug found by jannis where `dd` in PGR on a line that is not the last one doesn't copy the deletion
extension ASUT_NM_dd_Tests {
    
    func test_that_if_there_is_a_next_line_when_it_is_called_in_PGR_Mode_it_copies_the_deletion_in_UI_Elements_receptive_to_PGR() {
        let text = """
for example
  🇫🇷️t should stop
after the two spaces
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 53,
            caretLocation: 4,
            selectedLength: 1,
            selectedText: """
        e
        """,
            fullyVisibleArea: 0..<53,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 53,
                number: 1,
                start: 0,
                end: 12
            )!
        )
        copyToClipboard(text: "this should get overwritten")
        
        _ = applyMoveBeingTested(on: element, appFamily: .pgR)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "for example\n")
    }
    
}
