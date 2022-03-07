@testable import AccessibilityStrategy
import XCTest
import Common


// see VMC `d`
class ASUT_VML_d_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        vimEngineState.visualStyle = .linewise
        
        return asVisualMode.d(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
// no that accurate.
// see VMC c for more blah blah.
extension ASUT_VML_d_Tests {

    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_selected_text_even_for_an_empty_line() {
        let text = """
we gonna use VM
d here and we suppose
one extra line in between!
      ⛱️o go to non blank of the line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 102,
            caretLocation: 16,
            selectedLength: 49,
            selectedText: """
d here and we suppose
one extra line in between!\n
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 2,
                start: 16,
                end: 38
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 16
        AccessibilityStrategyVisualMode.head = 64
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
d here and we suppose
one extra line in between!\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}
