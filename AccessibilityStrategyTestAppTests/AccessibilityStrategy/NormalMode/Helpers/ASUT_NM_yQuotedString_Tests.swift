@testable import AccessibilityStrategy
import XCTest
import Common


// see cQuotedString for blah blah. same principle.
class ASUT_NM_yQuotedString_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(using quote: QuoteType, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        asNormalMode.yQuotedString(element.currentFileLine.innerQuotedString, quote, on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_yQuotedString_Tests {
    
    func test_that_when_it_finds_the_stuff_it_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion() {
        let text = """
again multiline
again
and now `hohohohoho`
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "h",
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 3,
                start: 22,
                end: 42
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(using: .backtick, on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "hohohohoho")
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }
    
    func test_that_when_it_does_not_find_the_stuff_it_Bips_and_does_not_change_the_LastYankingStyle_and_does_not_copy_anything() {
        let text = "some text without any double quote"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 34,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<34,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        copyToClipboard(text: "no double quote")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(using: .doubleQuote, on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "no double quote")
        XCTAssertTrue(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
    }
    
}


// Both
extension ASUT_NM_yQuotedString_Tests {
    
    func test_that_there_is_no_quote_it_does_not_move_or_copy_anything_and_does_not_touch_the_LastYankStyle() {
        let text = "some text without any double quote"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 34,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<34,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        copyToClipboard(text: "no double quote")
        
        var vimEngineState = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .doubleQuote, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "no double quote")
        XCTAssertEqual(returnedElement.caretLocation, 23)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_there_is_only_one_quote_it_does_not_move_or_copy_anything_either_and_does_not_touch_the_LastYankStyle() {
        let text = """
now there's one " double quote
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 30,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<30,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 30
            )!
        )
        copyToClipboard(text: "only one double quote")
        
        var vimEngineState = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .doubleQuote, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "only one double quote")
        XCTAssertEqual(returnedElement.caretLocation, 12)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_before_them_then_it_moves_the_caret_and_copy_the_text_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
now there's
two 'simple quotes' on the second line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 50,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<50,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 2,
                start: 12,
                end: 50
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "simple quotes")
        XCTAssertEqual(returnedElement.caretLocation, 17)  
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_between_them_then_it_moves_the_caret_and_copy_the_text_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
again multiline
again
and now `hohohohoho`
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "h",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 3,
                start: 22,
                end: 42
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .backtick, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "hohohohoho")
        XCTAssertEqual(returnedElement.caretLocation, 31)  
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_after_them_then_it_does_not_move_or_copy_anything_and_does_not_touch_the_LastYankStyle() {
        let text = """
double "quotes" before the caret
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 32,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<32,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 1,
                start: 0,
                end: 32
            )!
        )
        copyToClipboard(text: "caret after double quote")
        
        var vimEngineState = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .doubleQuote, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "caret after double quote")
        XCTAssertEqual(returnedElement.caretLocation, 26)  
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_there_are_three_double_quotes_and_the_caret_is_not_after_all_of_them_then_it_moves_the_caret_and_copy_the_right_text_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
heheheheh
'quote' and some more' yeyeyeye
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 41,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<41,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 41,
                number: 2,
                start: 10,
                end: 41
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), " and some more")
        XCTAssertEqual(returnedElement.caretLocation, 17)  
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_there_are_four_quotes_and_the_caret_is_exactly_on_the_third_one_it_calculates_the_matching_pairs_and_copy_the_right_text_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
now there's gonna
`be` for `quotes` yep
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 39,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: "`",
            fullyVisibleArea: 0..<39,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 2,
                start: 18,
                end: 39
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .backtick, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "quotes")
        XCTAssertEqual(returnedElement.caretLocation, 28)  
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// emojis
extension ASUT_NM_yQuotedString_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
need to deal with
those💨️💨️💨️ fac"🍵️s 🥺️☹️😂️ h😀️ha👅️" hhohohoo🤣️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 73,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<73,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 73,
                number: 2,
                start: 18,
                end: 52
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .doubleQuote, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "🍵️s 🥺️☹️😂️ h😀️ha👅️")
        XCTAssertEqual(returnedElement.caretLocation, 37)  
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
