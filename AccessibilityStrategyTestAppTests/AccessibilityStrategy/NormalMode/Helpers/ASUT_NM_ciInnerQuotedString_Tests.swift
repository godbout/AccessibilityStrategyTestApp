@testable import AccessibilityStrategy
import XCTest


// here we test the cases where the move does nothing because it can't find content between quotes.
// the rest is tested in UI, because PGR.
class ASUT_NM_ciInnerQuotedString_Tests: ASNM_BaseTests {
        
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 2,
                start: 12,
                end: 21
            )!
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "'", on: element, pgR: false)
        
        XCTAssertNil(returnedElement?.selectedText)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 26,
                number: 2,
                start: 7,
                end: 20
            )!
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "'", on: element, pgR: false)
        
        XCTAssertNil(returnedElement?.selectedText)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 98,
                number: 9,
                start: 82,
                end: 92
            )!
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "\"", on: element, pgR: false)
        
        XCTAssertNil(returnedElement?.selectedText)
    }

}
