@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_cj_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return asNormalMode.cj(on: element, &state)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.cj(on: element, &vimEngineState)
    }
    
}

    
// Bip, copy deletion and LYS
extension ASUT_NM_cj_Tests {

    func test_that_if_the_caret_is_on_the_lastLine_it_Bips_and_does_not_change_the_LastYankingStyle_and_does_not_copy_anything() {
        let text = """
well this move will Bip if
the caret is on the last line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<56,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 2,
                start: 27,
                end: 56
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertTrue(state.lastMoveBipped)
    }
    
    func test_that_in_other_cases_it_does_not_Bip_and_sets_the_LastYankingStyle_to_Linewise_and_copies_the_deletion_plus_the_lastLinefeed_if_any() {
        let text = """
ok now let's check
when the deleting
works. should be nice.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 59,
            caretLocation: 5,
            selectedLength: 1,
            selectedText: "w",
            fullyVisibleArea: 0..<59,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 59,
                number: 1,
                start: 0,
                end: 19
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
ok now let's check
when the deleting\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}
