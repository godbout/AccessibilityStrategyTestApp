@testable import AccessibilityStrategy
import XCTest


// this function is used for for ci", ci', and ci` 
class ASUT_NM_ciInnerQuotedString_Tests: ASNM_BaseTests {
    
    func test_that_if_the_caret_is_between_quotes_the_content_within_the_quotes_is_deleted_and_the_caret_moves() {
        let text = """
finally dealing with the "real stuff"!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 38,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 3,
                start: 21,
                end: 31
            )
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "\"", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 26)
        XCTAssertEqual(returnedElement?.selectedLength, 10)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
        
    // the change has been made! "does not move" means the returned element is the same as the one passed
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
            )
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "'", on: element)
        
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
            )
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "'", on: element)
        
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_caret_is_before_the_quotes_then_the_content_within_is_deleted_and_the_caret_moves() {
        let text = """
now the caret is before the ` shit with ` backtick quotes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 57,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "o",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 3,
                start: 17,
                end: 30
            )
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "`", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 29)
        XCTAssertEqual(returnedElement?.selectedLength, 11)
        XCTAssertEqual(returnedElement?.selectedText, "") 
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
            )
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "\"", on: element)
        
        XCTAssertNil(returnedElement?.selectedText)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 2,
                start: 9,
                end: 22
            )
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "'", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 8)
        XCTAssertEqual(returnedElement?.selectedLength, 14)
        XCTAssertEqual(returnedElement?.selectedText, "") 
    }
    
    func test_that_current_when_the_caret_is_at_a_quote_it_deletes_the_correct_content() {
        let text = """
that's " four quotes " in " there "
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: "\"",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 3,
                start: 21,
                end: 34
            )
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "\"", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 27)
        XCTAssertEqual(returnedElement?.selectedLength, 7)
        XCTAssertEqual(returnedElement?.selectedText, "") 
    }

}


// emojis
extension ASUT_NM_ciInnerQuotedString_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
need to deal with
those💨️💨️💨️ fac"es 🥺️☹️😂️ h😀️ha👅️" hhohohoo🤣️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 71,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "o",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 71,
                number: 3,
                start: 18,
                end: 33
            )
        )
        
        let returnedElement = asNormalMode.ciInnerQuotedString(using: "\"", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 37)
        XCTAssertEqual(returnedElement?.selectedLength, 21)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
