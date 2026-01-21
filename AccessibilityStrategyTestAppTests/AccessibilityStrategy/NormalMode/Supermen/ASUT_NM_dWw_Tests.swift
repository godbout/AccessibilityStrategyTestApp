@testable import AccessibilityStrategy
import XCTest
import Common


// UIT, PGR
class ASUT_NM_dWw_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.dWw(times: count, on: element, using: asNormalMode.w, &vimEngineState)
    }

}


// Bip, copy deletion and LYS
extension ASUT_NM_dWw_Tests {

    func test_that_for_a_word_that_is_not_at_the_end_of_a_line_it_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_proper_deletion() {
        let text = "😂️😂️😂️😂️hehehe gonna use ce on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 48,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: """
        😂️
        """,
            fullyVisibleArea: 0..<48,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 1,
                start: 0,
                end: 48
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "😂️😂️😂️")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_for_a_word_that_is_at_the_end_of_a_line_it_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_proper_deletion_which_means_without_the_Newline() {
        let text = """
ok my friend here
you shouldn't copy
the linefeed ok?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 53,
            caretLocation: 32,
            selectedLength: 1,
            selectedText: """
        c
        """,
            fullyVisibleArea: 0..<53,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 53,
                number: 2,
                start: 18,
                end: 37
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "copy")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_for_an_EmptyLine_it_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_an_empty_string() {
        let text = """
hehe empty lines


yes hehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 27,
            caretLocation: 17,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<27,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 2,
                start: 17,
                end: 18
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
}
