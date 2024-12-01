@testable import AccessibilityStrategy
import XCTest
import Common


// this move uses FT innerBlock which is already tested on its own.
// FT innerBlock returns the range of the text found, but doesn't care if the text
// spans on a line or several. this is up to cInnerBlock to handle this, which is
// what we need to test.
class ASUT_NM_cInnerBlock_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.cInnerBlock(using: openingBlock, on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
// here it is more complicated (after finishing the tests: WAY MORE COMPLICATED) than other moves as cInnerBlock may sometimes
// return Characterwise, sometimes Linewise.
// so for all the tests we're gonna test everything: caretLocation, selectedLength,
// selectedText, Bip, LYS, copy deletion.


// Both
extension ASUT_NM_cInnerBlock_Tests {
    
    func test_that_it_there_is_no_innerBlock_found_it_bips_and_does_not_copy_anything_and_does_not_change_the_LastYankStyle() {
        let text = "no block here"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 13,
            caretLocation: 6,
            selectedLength: 1,
            selectedText: """
        c
        """,
            fullyVisibleArea: 0..<13,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 13,
                number: 1,
                start: 0,
                end: 13
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertEqual(vimEngineState.lastMoveBipped, true)
    }
    
    func test_that_it_gets_the_content_between_two_brackets_on_a_same_line_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = "now th😄️at is ( some stuff 😄️😄️😄️on the same ) line😄️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 58,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<58,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 1,
                start: 0,
                end: 58
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), " some stuff 😄️😄️😄️on the same ")
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 33)
        XCTAssertEqual(returnedElement.selectedText, "")
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
    }
    
}


// TextViews
extension ASUT_NM_cInnerBlock_Tests {
  
    func test_that_it_gets_the_content_between_two_brackets_on_different_lines_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
this case is when { is not followed
by a linefeed
and } is not preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 85,
            caretLocation: 25,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<85,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 85,
                number: 1,
                start: 0,
                end: 36
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .leftBrace, on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
 is not followed
by a linefeed
and 
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 35)
        XCTAssertEqual(returnedElement.selectedText, "")
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
    }

    func test_that_if_the_closing_bracket_is_preceded_only_by_whitespaces_up_to_the_beginning_of_the_line_then_the_previous_line_linefeed_is_not_deleted_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
this case is when { is not followed
by a linefeed and
     } is preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 86,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<86,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 86,
                number: 1,
                start: 0,
                end: 36
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .leftBrace, on: element, &vimEngineState)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
 is not followed
by a linefeed and
"""
        )        
        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 34)
        XCTAssertEqual(returnedElement.selectedText, "")
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
    }
    
    func test_that_in_the_case_where_it_leaves_an_empty_line_between_the_brackets_it_positions_the_cursor_according_to_the_first_non_blank_of_the_first_line_that_is_after_the_opening_bracket_and_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise() {
        let text = """
now that shit will get cleaned (
    and the non blank
  will be respected!
)
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 77,
            caretLocation: 55,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<77,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 3,
                start: 55,
                end: 76
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &vimEngineState)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
    and the non blank
  will be respected!\n
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 37)
        XCTAssertEqual(returnedElement.selectedLength, 38)
        XCTAssertEqual(returnedElement.selectedText, "")
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
    }

    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_the_linefeed_is_not_deleted_and_it_does_not_Bip_and_it_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
this work when [
is followed by a linefeed
and ] is not preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: "d",
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 2,
                start: 17,
                end: 43
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &vimEngineState)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
is followed by a linefeed
and 
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertEqual(returnedElement.selectedText, "")
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
    }

    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_and_the_closing_bracket_is_immediately_preceded_by_a_linefeed_then_the_move_keeps_an_empty_line_between_the_brackets_and_it_does_not_Bip_and_it_sets_the_LastYankStyle_to_Linewise() {
        let text = """
this case is when (
is followed by a linefeed and
) is preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 77,
            caretLocation: 46,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<77,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 2,
                start: 20,
                end: 50
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
is followed by a linefeed and\n
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 29)
        XCTAssertEqual(returnedElement.selectedText, "")
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
    }

}
