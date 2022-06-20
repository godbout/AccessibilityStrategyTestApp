import XCTest
@testable import AccessibilityStrategy
import Common


class ASUT_NM_y$_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yDollarSign(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_y$_Tests {
    
    func test_that_if_the_FileLine_does_not_end_with_a_Linefeed_it_copies_from_the_caretLocation_to_the_LineEndLimit_included_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = "ok so now it's gonna be from caret to end limit"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 47,
            caretLocation: 21,
            selectedLength: 1,
            selectedText: """
        b
        """,
            fullyVisibleArea: 0..<47,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 47,
                number: 1,
                start: 0,
                end: 47
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "be from caret to end limit")
        XCTAssertEqual(returnedElement.caretLocation, 46)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
    
    func test_that_if_the_FileLine_ends_with_a_Linefeed_it_copies_from_the_caretLocation_to_the_LineEndLimit_included_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
ok so now we
gonn have linefeeds
finally
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 40,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: """
        i
        """,
            fullyVisibleArea: 0..<40,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 40,
                number: 2,
                start: 13,
                end: 33
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "inefeeds")
        XCTAssertEqual(returnedElement.caretLocation, 31)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
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
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
   
}
