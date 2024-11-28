@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_ck_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return asNormalMode.ck(on: element, &state)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.ck(on: element, &vimEngineState)
    }
    
}

    
// Bip, copy deletion and LYS
extension ASUT_NM_ck_Tests {

    func test_that_if_the_caret_is_on_the_first_line_it_Bips_and_does_not_change_the_LastYankingStyle_and_does_not_copy_anything() {
        let text = """
this move BIIIPS if
the caret is on the first file line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 55,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<55,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 55,
                number: 1,
                start: 0,
                end: 20
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertTrue(state.lastMoveBipped)
    }
    
    func test_that_in_other_cases_it_does_not_Bip_and_sets_the_LastYankingStyle_to_Linewise_and_copies_the_deletion_plus_the_last_linefeed_if_any() {
        let text = """
ok now let's check
when the deleting
works. should be nice.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<60,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 2,
                start: 19,
                end: 37
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
