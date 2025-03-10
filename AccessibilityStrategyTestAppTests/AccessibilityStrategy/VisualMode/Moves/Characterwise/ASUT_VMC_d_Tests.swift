@testable import AccessibilityStrategy
import XCTest
import Common


// here we test the Bip, LYS and copy selected text
// rest in UIT coz repositioning cursor and now also PGR
class ASUT_VMC_d_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto, visualStyle: .characterwise)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        vimEngineState.visualStyle = .characterwise
        
        return asVisualMode.d(on: element, &vimEngineState)
    }
    
}



// Bip, copy deletion and LYS
// no that accurate. see c for blah blah.
extension ASUT_VMC_d_Tests {

    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_selected_text_even_for_an_empty_line() {
        let text = """
all that VM d does
in characterwi😂️e is deleting
the selection!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 64,
            caretLocation: 14,
            selectedLength: 19,
            selectedText: "does\nin characterwi",
            fullyVisibleArea: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 1,
                start: 0,
                end: 19
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
does
in characterwi
"""
        )
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
}
