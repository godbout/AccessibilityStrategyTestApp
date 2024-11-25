@testable import AccessibilityStrategy
import XCTest
import Common


// in UIT. dip is not calling cip.
class ASUT_NM_dip_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.dip(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_dip_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_deletion_including_the_last_Linefeed_of_the_paragraph() {
        let text = """
this is to check
that

the block cursor
ends up in the
right

place
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 67,
            caretLocation: 55,
            selectedLength: 1,
            selectedText: """
        r
        """,
            fullyVisibleArea: 0..<67,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 67,
                number: 6,
                start: 55,
                end: 61
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
the block cursor
ends up in the
right\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}
