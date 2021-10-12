@testable import AccessibilityStrategy
import XCTest


class FL_innerQuotedString_Tests: XCTestCase {}


// Both
extension FL_innerQuotedString_Tests {
    
    func test_that_if_there_is_no_quote_then_it_returns_nil() throws {
        let text = "yep no quote in here"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 2)
        )
        
        XCTAssertNil(
            fileLine.innerQuotedString(using: "\"", startingAt: 2)
        )
    }
    
    func test_that_if_there_is_only_one_quote_then_it_returns_nil_also() throws {
        let text = "only one quote in 'there"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 6)
        )
        
        XCTAssertNil(
            fileLine.innerQuotedString(using: "'", startingAt: 7)
        )
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_before_them_then_it_can_find_the_text() throws {
        let text = "finally some serious 'gourmet' shit"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 4)
        )
        
        guard let quotedStringRange = fileLine.innerQuotedString(using: "'", startingAt: 4) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 22)
        XCTAssertEqual(quotedStringRange.upperBound, 29) 
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_between_them_then_it_can_find_the_text() throws {
        let text = "wow now we're gonna eat shit a bit' lol"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 15)
        )
        
        guard let quotedStringRange = fileLine.innerQuotedString(using: "'", startingAt: 15) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 11)
        XCTAssertEqual(quotedStringRange.upperBound, 34) 
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_after_them_then_it_returns_nil() throws {
        let text = "pretty `tough` if you ask me"
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 18)
        )
        
        XCTAssertNil(
            fileLine.innerQuotedString(using: "`", startingAt: 18)
        )
    }
    
    func test_that_if_there_are_three_quotes_it_finds_the_correct_text() throws {
        let text = """
that's " three quotes " in there "
"""
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 29)
        )
        
        guard let quotedStringRange = fileLine.innerQuotedString(using: "\"", startingAt: 29) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 23)
        XCTAssertEqual(quotedStringRange.upperBound, 33) 
    }
    
    func test_that_if_the_caret_is_on_a_quote_then_it_calculates_the_matching_pairs_and_finds_the_correct_text() throws {
        let text = """
several "pairs" here and kindaVim should "know" which one to delete
"""
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 41)
        )
        
        guard let quotedStringRange = fileLine.innerQuotedString(using: "\"", startingAt: 41) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 42)
        XCTAssertEqual(quotedStringRange.upperBound, 46) 
    }
    
    func test_some_more_that_if_the_caret_is_on_a_quote_then_it_calculates_the_matching_pairs_and_finds_the_correct_text() throws {
        let text = """
several "pairs" here and kindaVim should "know which one to delete
"""
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 41)
        )
        
        XCTAssertNil(
            fileLine.innerQuotedString(using: "\"", startingAt: 41)
        )
    }
    
    func test_that_if_the_string_is_empty_it_returns_nil() throws {
        let text = ""
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 0)
        )
        
        XCTAssertNil(
            fileLine.innerQuotedString(using: "\"", startingAt: 0)
        )
    }
    
    func test_that_if_the_line_with_quotes_is_not_the_first_one_it_still_fucking_works() throws {
        let text = """
so i'm a line first
and then the "real" shit
and currently i fail
"""
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 24)
        )
        
        guard let quotedStringRange = fileLine.innerQuotedString(using: "\"", startingAt: 26) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 34)
        XCTAssertEqual(quotedStringRange.upperBound, 38) 
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_innerQuotedString_Tests {
    
    func test_that_it_handles_emojis() throws {
        let text = """
emojis are sy🧑‍🌾️🧑‍🌾️mbols" that 🔫️🔫️🔫️ are longer" than 1 length
"""
        
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 9)
        )
        
        guard let quotedStringRange = fileLine.innerQuotedString(using: "\"", startingAt: 9) else { return XCTFail() }
        
        XCTAssertEqual(quotedStringRange.lowerBound, 31)
        XCTAssertEqual(quotedStringRange.upperBound, 57) 
    }
    
}

