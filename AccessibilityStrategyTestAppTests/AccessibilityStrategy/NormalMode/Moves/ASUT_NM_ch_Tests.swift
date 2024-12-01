@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_ch_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.ch(times: count, on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS, AND count
// count is included now in moves that copy deletion because it will affect what is copied.
extension ASUT_NM_ch_Tests {
    
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
            selectedText: "a",
            fullyVisibleArea: 0..<93,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 93,
                number: 2,
                start: 41,
                end: 73
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_if_the_newCaretLocation_after_the_move_ends_up_at_the_start_of_the_line_then_it_does_not_Bip_but_change_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_up_to_the_start_of_the_line() {
        let text = "ch should delete the correct character😂️😂️😂️😂️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 50,
            caretLocation: 38,
            selectedLength: 3,
            selectedText: "😂️",
            fullyVisibleArea: 0..<50,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 1,
                start: 0,
                end: 50
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 5, on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "acter")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_if_the_newCaretLocation_after_the_move_ends_up_after_the_start_of_the_line_then_it_does_not_Bip_but_change_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_up_to_the_newCaretLocation() {
        let text = "ch should delete the correct character😂️😂️😂️😂️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 50,
            caretLocation: 38,
            selectedLength: 3,
            selectedText: "😂️",
            fullyVisibleArea: 0..<50,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 1,
                start: 0,
                end: 50
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 128, on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "ch should delete the correct character")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)        
    }
    
}
