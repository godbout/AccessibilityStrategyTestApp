@testable import AccessibilityStrategy
import XCTest


class FL_innerQuotedString_Tests: XCTestCase {}


// Both
extension FL_innerQuotedString_Tests {
    
    func test_that_if_there_is_no_quote_then_it_returns_nil() {
        let text = "yep no quote in here"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 20,
            caretLocation: 2,
            selectedLength: 2,
            selectedText: "p ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 20,
                number: 1,
                start: 0,
                end: 20
            )
        )
        
        XCTAssertNil(
            element.currentFileLine.innerQuotedString(using: "\"", startingAt: 2)
        )
    }
    
    func test_that_if_there_is_only_one_quote_then_it_returns_nil_also() {
        let text = "only one quote in 'there"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 24,
            caretLocation: 6,
            selectedLength: 1,
            selectedText: "n",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 24,
                number: 1,
                start: 0,
                end: 9
            )
        )
        
        XCTAssertNil(
            element.currentFileLine.innerQuotedString(using: "'", startingAt: 7)
        )
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_before_them_then_it_can_find_the_text() {
        let text = "finally some serious 'gourmet' shit"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 4,
            selectedLength: 1,
            selectedText: "l",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 1,
                start: 0,
                end: 13
            )
        )
        
        guard let quotedStringRange = element.currentFileLine.innerQuotedString(using: "'", startingAt: 4) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 22)
        XCTAssertEqual(quotedStringRange.upperBound, 29) 
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_between_them_then_it_can_find_the_text() {
        let text = "wow now we're gonna eat shit a bit' lol"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 39,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "o",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 2,
                start: 8,
                end: 20
            )
        )
        
        guard let quotedStringRange = element.currentFileLine.innerQuotedString(using: "'", startingAt: 15) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 11)
        XCTAssertEqual(quotedStringRange.upperBound, 34) 
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_after_them_then_it_returns_nil() {
        let text = "pretty `tough` if you ask me"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "y",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 3,
                start: 18,
                end: 28
            )
        )
        
        XCTAssertNil(
            element.currentFileLine.innerQuotedString(using: "`", startingAt: 18)
        )
    }
    
    func test_that_if_there_are_three_quotes_it_finds_the_correct_text() {
        let text = """
that's " three quotes " in there "
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 34,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 2,
                start: 24,
                end: 34
            )
        )
        
        guard let quotedStringRange = element.currentFileLine.innerQuotedString(using: "\"", startingAt: 29) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 23)
        XCTAssertEqual(quotedStringRange.upperBound, 33) 
    }
    
    func test_that_if_the_caret_is_on_a_quote_then_it_calculates_the_matching_pairs_and_finds_the_correct_text() {
        let text = """
several "pairs" here and kindaVim should "know" which one to delete
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 67,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: "\"",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 67,
                number: 2,
                start: 25,
                end: 48
            )
        )
        
        guard let quotedStringRange = element.currentFileLine.innerQuotedString(using: "\"", startingAt: 41) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 42)
        XCTAssertEqual(quotedStringRange.upperBound, 46) 
    }
    
    func test_some_more_that_if_the_caret_is_on_a_quote_then_it_calculates_the_matching_pairs_and_finds_the_correct_text() {
        let text = """
several "pairs" here and kindaVim should "know which one to delete
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 66,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: "\"",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 2,
                start: 25,
                end: 47
            )
        )
        
        XCTAssertNil(
            element.currentFileLine.innerQuotedString(using: "\"", startingAt: 41)
        )
    }
    
    func test_that_if_the_string_is_empty_it_returns_nil() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )
        )
        
        XCTAssertNil(
            element.currentFileLine.innerQuotedString(using: "\"", startingAt: 0)
        )
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_innerQuotedString_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
emojis are sy🧑‍🌾️🧑‍🌾️mbols" that 🔫️🔫️🔫️ are longer" than 1 length
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 72,
            caretLocation: 9,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 1,
                start: 0,
                end: 32
            )
        )
        
        guard let quotedStringRange = element.currentFileLine.innerQuotedString(using: "\"", startingAt: 9) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 31)
        XCTAssertEqual(quotedStringRange.upperBound, 57) 
    }
    
}

