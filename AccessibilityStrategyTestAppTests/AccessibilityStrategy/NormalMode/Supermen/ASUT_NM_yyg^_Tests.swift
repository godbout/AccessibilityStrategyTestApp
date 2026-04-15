import XCTest
@testable import AccessibilityStrategy
import Common


class ASUT_NM_yygCaret_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yygCaret(using: element.currentScreenLine, on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_yygCaret_Tests {
    
    func test_that_if_the_caret_is_before_the_FirstNonBlankLimit_of_the_line_then_it_copies_from_the_caretLocation_to_the_FirstNonBlankLimit_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_actually_does_not_even_move_the_caret_WOT() {
        let text = "    so let's see if the caret is BEFORE the first non blank hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 64,
            caretLocation: 1,
            selectedLength: 1,
            selectedText: """
         
        """,
            fullyVisibleArea: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 1,
                start: 0,
                end: 64
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "   ")
        XCTAssertEqual(returnedElement.caretLocation, 1)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }
    
    func test_that_if_the_caret_is_already_at_the_FirstNonBlankLimit_of_the_line_then_it_fills_the_Pasteboard_with_an_empty_string_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_of_course_does_not_move_the_caret() {
        let text = "    so let's see if the caret is AT the first non blank hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 60,
            caretLocation: 4,
            selectedLength: 1,
            selectedText: """
        s
        """,
            fullyVisibleArea: 0..<60,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 1,
                start: 0,
                end: 60
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }
        
    func test_that_if_the_caret_is_after_the_FirstNonBlankLimit_of_the_line_then_it_copies_from_the_FirstNonBlankLimit_to_the_caretLocation_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_in_this_case_moves_the_caret_to_the_FirstNonBlankLimit_of_the_line() {
        let text = "    so let's see if the caret is after the first non blank hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 63,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: """
        e
        """,
            fullyVisibleArea: 0..<63,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 63,
                number: 1,
                start: 0,
                end: 63
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "so let's see if th")
        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }
    
    func test_that_for_an_EmptyLine_it_fills_the_Pasteboard_with_an_empty_string_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
that's gonna be

a little more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 16,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<30,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 2,
                start: 16,
                end: 17
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }
    
    func test_that_for_a_BlankLine_it_behaves_like_if_the_caret_is_before_the_FirstNonBlankLimit_because_it_does_LMAO() {
        let text = """
that's gonna be
         
a little more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 40,
            caretLocation: 17,
            selectedLength: 1,
            selectedText: """
         
        """,
            fullyVisibleArea: 0..<40,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 40,
                number: 2,
                start: 16,
                end: 26
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "       ")
        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }

}
