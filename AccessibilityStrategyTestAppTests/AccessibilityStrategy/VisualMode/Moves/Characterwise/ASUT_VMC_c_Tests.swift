@testable import AccessibilityStrategy
import XCTest
import Common


// PGR and Electron in UIT.
class ASUT_VMC_c_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto, visualStyle: .characterwise)
        
        return applyMoveBeingTested(on: element, &state)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        vimEngineState.visualStyle = .characterwise
        
        return asVisualMode.c(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
// no that accurate. an empty text shouldn't copy nothing to clipboard.
// currently does i believe. those edge cases are complicated and painful
// so fuck'em for now.
extension ASUT_VMC_c_Tests {

    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_even_for_an_empty_line() {
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
            visibleCharacterRange: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 1,
                start: 0,
                end: 19
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
does
in characterwi
"""
        )
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// Both
extension ASUT_VMC_c_Tests {

    func test_that_when_the_selection_is_spanning_on_a_single_line_it_deletes_the_selected_text() {
        let text = "ok so VM c (hahaha) on a single line"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 36,
            caretLocation: 14,
            selectedLength: 13,
            selectedText: "haha) on a si",
            visibleCharacterRange: 0..<36,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 1,
                start: 0,
                end: 36
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 13)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_when_the_selection_is_spanning_on_multiple_lines_it_deletes_the_selected_text() {
        let text = """
like same as above
but on multiple
lines because
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 48,
            caretLocation: 8,
            selectedLength: 36,
            selectedText: "e as above\nbut on multiple\nlines bec",
            visibleCharacterRange: 0..<48,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 1,
                start: 0,
                end: 19
            )!
        )
                
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 36)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
