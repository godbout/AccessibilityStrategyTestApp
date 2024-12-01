@testable import AccessibilityStrategy
import XCTest
import Common


// moved to UI Tests coz PGR
class ASUT_NM_dG__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState ) -> AccessibilityTextElement {
        return asNormalMode.dG(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
// not totally accurate. see ASUT cG for more blah blah.
extension ASUT_NM_dG__Tests {
    
    func test_that_when_it_is_on_an_empty_text_it_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_an_empty_string() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: """

        """,
            fullyVisibleArea: 0..<0,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
        copyToClipboard(text: "nope you don't copy mofo")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_empty_line_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_deletion() {
        let text = """
blah blah some line
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: """
        s
        """,
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 2,
                start: 20,
                end: 30
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        )
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }

}
