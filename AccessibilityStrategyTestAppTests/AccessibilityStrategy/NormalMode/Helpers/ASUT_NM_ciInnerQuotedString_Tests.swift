@testable import AccessibilityStrategy
import XCTest


// here we test the cases where the move does nothing because it can't find content between quotes.
// we also test the Bipped.
// the rest is tested in UI, because PGR.
class ASUT_NM_ciInnerQuotedString_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(using quote: Character, on element: AccessibilityTextElement?, _ bipped: inout Bool) -> AccessibilityTextElement? {
        return asNormalMode.ciInnerQuotedString(using: quote, on: element, pgR: false, &bipped)
    }
    
}


// copy deleted text
extension ASUT_NM_ciInnerQuotedString_Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 1,
                start: 0,
                end: 38
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var bipped = false
        _ = applyMoveBeingTested(using: "\"", on: element, &bipped)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "real stuff")
    }
    
}


// bipped
extension ASUT_NM_ciInnerQuotedString_Tests {
    
    func test_that_it_does_not_Bip_when_it_can_find() {
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 1,
                start: 0,
                end: 38
            )!
        )
        
        var bipped = false
        let _ = applyMoveBeingTested(using: "\"", on: element, &bipped)
        
        XCTAssertFalse(bipped)
    }
        
    func test_that_it_Bips_when_it_cannot_find() {
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        
        var bipped = false
        let _ = applyMoveBeingTested(using: "\"", on: element, &bipped)
        
        XCTAssertTrue(bipped)
    }
    
}


extension ASUT_NM_ciInnerQuotedString_Tests {
    
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 1,
                start: 0,
                end: 38
            )!
        )
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(using: "\"", on: element, &bipped)
        
        XCTAssertEqual(returnedElement?.caretLocation, 26)
        XCTAssertEqual(returnedElement?.selectedLength, 10)
        XCTAssertEqual(returnedElement?.selectedText, "")
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 98,
                number: 1,
                start: 0,
                end: 60
            )!
        )
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(using: "`", on: element, &bipped)
        
        XCTAssertEqual(returnedElement?.caretLocation, 39)
        XCTAssertEqual(returnedElement?.selectedLength, 30)
        XCTAssertEqual(returnedElement?.selectedText, "")
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
                number: 1,
                start: 0,
                end: 32
            )!
        )
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(using: "'", on: element, &bipped)
        
        XCTAssertEqual(returnedElement?.caretLocation, 8)
        XCTAssertEqual(returnedElement?.selectedLength, 14)
        XCTAssertEqual(returnedElement?.selectedText, "")
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 1,
                start: 0,
                end: 35
            )!
        )
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(using: "\"", on: element, &bipped)
        
        XCTAssertEqual(returnedElement?.caretLocation, 27)
        XCTAssertEqual(returnedElement?.selectedLength, 7)
        XCTAssertEqual(returnedElement?.selectedText, "")
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 2,
                start: 12,
                end: 21
            )!
        )
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(using: "'", on: element, &bipped)
        
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
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(using: "'", on: element, &bipped)
        
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
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(using: "\"", on: element, &bipped)
        
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
