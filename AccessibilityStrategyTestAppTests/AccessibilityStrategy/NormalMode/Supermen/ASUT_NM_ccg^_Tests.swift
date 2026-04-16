@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_ccgCaret_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        // see cgg$ for blah blah
        return asNormalMode.ccgCaret(using: element.currentFileLine, on: element, &vimEngineState) 
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_ccgCaret_Tests {
    
    func test_that_if_the_caret_is_at_the_FirstNonBlankLimit_it_does_not_Bip_and_does_not_change_the_LastYankStyle_and_does_not_copy_anything() {
        let text = """
    hello dear friend
   😂️hat's some text
  and also some more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 64,
            caretLocation: 25,
            selectedLength: 3,
            selectedText: """
        😂️
        """,
            fullyVisibleArea: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 2,
                start: 22,
                end: 44
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_if_the_caret_is_before_the_FirstNonBlankLimit_it_also_does_not_Bip_but_it_changes_the_LastYankStyle_to_Characterwise_and_copies_from_the_caretLocation_to_the_FirstNonBlankLimit() {
        let text = """
    hello dear friend
   😂️hat's some text
  and also some more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 64,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: """
         
        """,
            fullyVisibleArea: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 2,
                start: 22,
                end: 44
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "  ")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_if_the_caret_is_after_the_FirstNonBlankLimit_it_also_does_not_Bip_but_it_changes_the_LastYankStyle_to_Characterwise_and_copies_from_the_caretLocation_to_the_FirstNonBlankLimit() {
        let text = """
    hello dear friend
   😂️hat's some text
  and also some more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 64,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: """
        e
        """,
            fullyVisibleArea: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 2,
                start: 22,
                end: 44
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "😂️hat's som")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
}
