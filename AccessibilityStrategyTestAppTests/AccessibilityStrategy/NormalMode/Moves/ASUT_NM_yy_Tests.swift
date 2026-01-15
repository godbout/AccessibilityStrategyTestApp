@testable import AccessibilityStrategy
import XCTest
import Common


// yy doesn't touch the caret position or anything else, it just copies
// the line into the NSPasteBoard.
class ASUT_NM_yy_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(times: count, on: element, &vimEngineState)
    }
        
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yy(times: count, on: element, &vimEngineState)
    }
    
}


// line
extension ASUT_NM_yy_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 40,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<115,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 27,
                end: 54
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "this move does not stop at screen lines. it will just pass by\n")
        XCTAssertEqual(returnedElement.caretLocation, 40)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// Bip, copy and LYS, AND count
extension ASUT_NM_yy_Tests {
    
    func test_that_for_an_EmptyLine_it_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_emptiness() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<0,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_without_a_count_it_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_one_line() {
        let text = """
looks like it's late coz it's getting harder to reason
but actually it's only 21.43 LMAOOOOOOOO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 95,
            caretLocation: 38,
            selectedLength: 1,
            selectedText: "h",
            fullyVisibleArea: 0..<95,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 95,
                number: 1,
                start: 0,
                end: 55
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "looks like it's late coz it's getting harder to reason\n")
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_with_a_count_that_is_not_too_high_it_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_lines() {
        let text = """
ok now we gonna copy
a couple of lines
and everybody will
        be happy
until the end
of days.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 97,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: "l",
            fullyVisibleArea: 0..<97,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 97,
                number: 2,
                start: 21,
                end: 39
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(times: 3, on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
a couple of lines
and everybody will
        be happy\n
"""
        )
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_with_a_count_that_is_too_high_it_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_lines_until_the_end_of_the_text() {
        let text = """
ok now we gonna copy
a couple of lines
and everybody will
        be happy
until the end
of days.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 97,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: "l",
            fullyVisibleArea: 0..<97,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 97,
                number: 2,
                start: 21,
                end: 39
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(times: 69, on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
a couple of lines
and everybody will
        be happy
until the end
of days.
"""
        )
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
        
}


// Both
extension ASUT_NM_yy_Tests {
    
    func test_that_in_normal_setting_it_copies_the_line_into_the_buffer() {
        let text = "is that gonna be copied?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 24,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<24,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 24,
                number: 1,
                start: 0,
                end: 24
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), text)
        XCTAssertEqual(returnedElement.caretLocation, 12)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_includes_the_end_of_the_line_linefeed() {
        let text = 
"""
some very long multiple lines just to be sure that it
workd properly my friend
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 39,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 2,
                start: 24,
                end: 46
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some very long multiple lines just to be sure that it\n")
        XCTAssertEqual(returnedElement.caretLocation, 39)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_does_not_include_the_linefeed_of_the_previous_line() {
        let text = 
            """
some more long multiple lines for you because you're my best friend
again yes i know i've said 😂️ this but i need them long
my friend
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 134,
            caretLocation: 95,
            selectedLength: 3,
            selectedText: "😂️",
            fullyVisibleArea: 0..<134,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 134,
                number: 2,
                start: 68,
                end: 125
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "again yes i know i've said 😂️ this but i need them long\n")
        XCTAssertEqual(returnedElement.caretLocation, 95)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_text_is_empty_it_works_and_copies_the_EmptyLine() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<0,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
        copyToClipboard(text: "test 1 of The 3 Cases")
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_text_and_on_an_EmptyLine_on_its_own_it_works_and_copies_the_line() {
        let text = """
caret is on its
own empty
line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 31,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 4,
                start: 31,
                end: 31
            )!
        )
        copyToClipboard(text: "test 3 of The 3 cases")
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement.caretLocation, 31)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }    
    
}
