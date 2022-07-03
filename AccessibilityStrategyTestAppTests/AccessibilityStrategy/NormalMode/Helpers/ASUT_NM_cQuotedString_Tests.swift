@testable import AccessibilityStrategy
import XCTest
import Common


// this move uses FL aQuotedString or innerQuotedString, those are heavily tested on their own.
// this move is also used by all the ca'"` ci'"` moves. they each respectively have tests
// to make sure that they're sending the right parameters to cQuotedString.


// PGR and Electron in UIT
class ASUT_NM_cQuotedString_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(using quote: QuoteType, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(using: quote, on: element, &state)
    }
    
    // we do all the tests with innerQuotedString, but we're testing we pass the right parameters everywhere else.
    private func applyMoveBeingTested(using quote: QuoteType, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        asNormalMode.cQuotedString(element.currentFileLine.innerQuotedString, quote, on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_cQuotedString_Tests {
    
    func test_that_when_it_finds_the_stuff_it_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion() {
        let text = """
finally dealing with the "real stuff"!
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 38,
            caretLocation: 16,
            selectedLength: 1,
            selectedText: "w",
            fullyVisibleArea: 0..<38,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 1,
                start: 0,
                end: 38
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(using: .doubleQuote, on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "real stuff")
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
        
    func test_that_when_it_does_not_find_the_stuff_it_Bips_and_does_not_change_the_LastYankingStyle_and_does_not_copy_anything() {
        let text = """
finally dealing with the "real stuff!
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 37,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(using: .doubleQuote, on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .linewise)
    }
    
}


extension ASUT_NM_cQuotedString_Tests {
    
    func test_that_if_the_caret_is_between_quotes_the_content_within_the_quotes_is_deleted_and_the_caret_moves() {
        let text = """
finally dealing with the "real stuff"!
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 38,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "l",
            fullyVisibleArea: 0..<38,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 1,
                start: 0,
                end: 38
            )!
        )
        
        let returnedElement = applyMoveBeingTested(using: .doubleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 26)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
        
    func test_that_if_the_caret_is_before_the_quotes_then_the_content_within_is_deleted_and_the_caret_moves() {
        let text = """
now the caret 💨️💨️💨️ is before the ` shit with 🥺️☹️😂️ h😀️ha👅️ ` backtick quotes hhohohoo🤣️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 98,
            caretLocation: 31,
            selectedLength: 1,
            selectedText: "r",
            fullyVisibleArea: 0..<98,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 98,
                number: 1,
                start: 0,
                end: 60
            )!
        )
        
        let returnedElement = applyMoveBeingTested(using: .backtick, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 39)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertEqual(returnedElement.selectedText, "")
    }

    func test_that_if_there_are_three_quotes_then_the_correct_content_is_deleted_and_the_caret_moves() {
        let text = """
that's ' three quotes ' in there
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 17,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<32,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 1,
                start: 0,
                end: 32
            )!
        )
        
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 14)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_current_when_the_caret_is_at_a_quote_it_deletes_the_correct_content() {
        let text = """
that's " four quotes " in " there "
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 35,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: "\"",
            fullyVisibleArea: 0..<35,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 1,
                start: 0,
                end: 35
            )!
        )
        
        let returnedElement = applyMoveBeingTested(using: .doubleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 27)
        XCTAssertEqual(returnedElement.selectedLength, 7)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_if_there_is_only_one_quote_no_content_is_deleted_and_the_caret_does_not_move() {
        let text = """
a text with only one quote ' lol
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 17,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<32,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 2,
                start: 12,
                end: 21
            )!
        )
        
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element)
        
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_there_are_no_quote_no_content_is_deleted_and_the_caret_does_not_move() {
        let text = "now no double quote at all"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 26,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<26,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 26,
                number: 2,
                start: 7,
                end: 20
            )!
        )
        
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element)
        
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_caret_is_after_the_quotes_then_no_content_is_deleted_and_the_caret_does_not_move() {
        let text = """
adding some lines on top because
it doesn't pass for long text
now the "caret" is after the quotes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 98,
            caretLocation: 85,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<98,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 98,
                number: 9,
                start: 82,
                end: 92
            )!
        )
        
        let returnedElement = applyMoveBeingTested(using: .doubleQuote, on: element)
        
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_quoteString_is_not_on_the_first_FileLine_it_still_works_and_does_not_crash_LOL() {
        let text = """
adding some lines on top because
it doesn't pass for long text
now the `caret` is after the quotes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 98,
            caretLocation: 69,
            selectedLength: 1,
            selectedText: """
        e
        """,
            fullyVisibleArea: 0..<98,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 98,
                number: 3,
                start: 63,
                end: 98
            )!
        )
        
        let returnedElement = applyMoveBeingTested(using: .backtick, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 72)
        XCTAssertEqual(returnedElement.selectedLength, 5)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
