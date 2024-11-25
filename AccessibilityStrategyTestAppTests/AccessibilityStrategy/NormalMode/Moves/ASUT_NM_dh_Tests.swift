@testable import AccessibilityStrategy
import XCTest
import Common


// UIT, PGR blah blah
class ASUT_NM_dh_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.dh(times: count, on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS, AND count
extension ASUT_NM_dh_Tests {
    
    // this case includes empty lines
    func test_that_if_the_caret_is_at_the_start_of_a_line_it_does_not_Bip_and_does_not_change_the_LastYankStyle_and_does_not_copy_anything() {
        let text = """
so we're at the start of the second line
and a shouldn't get deleted and
we should stay there
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 93,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: """
        a
        """,
            fullyVisibleArea: 0..<93,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 93,
                number: 3,
                start: 41,
                end: 61
            )!
        )
      
        copyToClipboard(text: "nope you don't copy mofo")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "nope you don't copy mofo")
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_if_the_newCaretLocation_after_the_move_ends_up_at_the_start_of_the_line_then_it_does_not_Bip_but_change_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_up_to_the_start_of_the_line() {
        let text = "X should delete the right character😂️😂️😂️😂️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 47,
            caretLocation: 35,
            selectedLength: 3,
            selectedText: """
        😂️
        """,
            fullyVisibleArea: 0..<47,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 47,
                number: 1,
                start: 0,
                end: 47
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 5, on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "acter")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_if_the_newCaretLocation_after_the_move_ends_up_after_the_start_of_the_line_then_it_does_not_Bip_but_change_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_up_to_the_newCaretLocation() {
        let text = "X should delete the right character😂️😂️😂️😂️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 47,
            caretLocation: 35,
            selectedLength: 3,
            selectedText: """
        😂️
        """,
            fullyVisibleArea: 0..<47,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 47,
                number: 1,
                start: 0,
                end: 47
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 128, on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "X should delete the right character")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}
