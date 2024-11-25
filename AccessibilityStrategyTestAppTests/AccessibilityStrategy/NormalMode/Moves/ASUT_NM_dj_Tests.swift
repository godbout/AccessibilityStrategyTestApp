@testable import AccessibilityStrategy
import XCTest
import Common


// moves in UI Tests.
class ASUT_NM_dj_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.dj(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_dj_Tests {
    
    func test_that_when_it_can_delete_the_stuff_it_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_deletion() {
        let text = """
now 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
becau🤡️se it w🤡️🤡️ill go 🤡️to the🤡️ next
     🤡️o🤡️n b🤡️lank of 🤡️this line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 124,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: """
        n
        """,
            fullyVisibleArea: 0..<124,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 124,
                number: 1,
                start: 0,
                end: 27
            )!
        )
        
        copyToClipboard(text: "nope you don't copy mofo")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
now 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
becau🤡️se it w🤡️🤡️ill go 🤡️to the🤡️ next\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_when_it_cannot_delete_the_stuff_it_Bips_and_does_not_change_the_the_LastYankStyle_and_does_not_copy_anything() {
        let text = "one line is not enough for dj 😀️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 33,
            caretLocation: 30,
            selectedLength: 3,
            selectedText: """
        😀️
        """,
            fullyVisibleArea: 0..<33,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 33,
                number: 1,
                start: 0,
                end: 33
            )!
        )
        
        copyToClipboard(text: "nope you don't copy mofo")
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "nope you don't copy mofo")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertTrue(state.lastMoveBipped)
    }
    
}
