@testable import AccessibilityStrategy
import XCTest


class FL_innerQuotedString_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, using quote: QuoteType, startingAt caretLocation: Int) throws -> Range<Int>? {
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: caretLocation)
        )
                
        return fileLine.innerQuotedString(using: quote, startingAt: caretLocation)
    }
    
}


// Both
extension FL_innerQuotedString_Tests {
    
    func test_that_if_there_is_no_quote_then_it_returns_nil() {
        let text = "yep no quote in here"
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .doubleQuote, startingAt: 2)
        
        XCTAssertNil(innerQuotedStringRange)
    }
    
    func test_that_if_there_is_only_one_quote_then_it_returns_nil_also() {
        let text = "only one quote in 'there"
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .singleQuote, startingAt: 6)

        XCTAssertNil(innerQuotedStringRange)
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_before_them_then_it_can_find_the_text() {
        let text = "finally some serious 'gourmet' shit"
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .singleQuote, startingAt: 4)
        
        XCTAssertEqual(innerQuotedStringRange?.lowerBound, 22)
        XCTAssertEqual(innerQuotedStringRange?.upperBound, 29) 
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_between_them_then_it_can_find_the_text() {
        let text = "wow now we're gonna eat shit a bit' lol"
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .singleQuote, startingAt: 15)
        
        XCTAssertEqual(innerQuotedStringRange?.lowerBound, 11)
        XCTAssertEqual(innerQuotedStringRange?.upperBound, 34) 
    }
    
    func test_that_if_there_are_two_quotes_and_the_caret_is_after_them_then_it_returns_nil() {
        let text = "pretty `tough` if you ask me"
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .backtick, startingAt: 15)
        
        XCTAssertNil(innerQuotedStringRange)
    }
    
    func test_that_if_there_are_three_quotes_it_finds_the_correct_text() {
        let text = """
that's " three quotes " in there "
"""
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .doubleQuote, startingAt: 29)
        
        XCTAssertEqual(innerQuotedStringRange?.lowerBound, 23)
        XCTAssertEqual(innerQuotedStringRange?.upperBound, 33) 
    }
    
    func test_that_if_the_caret_is_on_a_quote_then_it_calculates_the_matching_pairs_and_finds_the_correct_text() {
        let text = """
several "pairs" here and kindaVim should "know" which one to delete
"""
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .doubleQuote, startingAt: 41)
        
        XCTAssertEqual(innerQuotedStringRange?.lowerBound, 42)
        XCTAssertEqual(innerQuotedStringRange?.upperBound, 46) 
    }
    
    func test_some_more_that_if_the_caret_is_on_a_quote_then_it_calculates_the_matching_pairs_and_finds_the_correct_text() {
        let text = """
several "pairs" here and kindaVim should "know which one to delete
"""
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .doubleQuote, startingAt: 41)
        
        XCTAssertNil(innerQuotedStringRange)
    }
    
    func test_that_if_the_string_is_empty_it_returns_nil() {
        let text = ""
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .doubleQuote, startingAt: 0)
        
        XCTAssertNil(innerQuotedStringRange)
    }
    
}


// TextViews
extension FL_innerQuotedString_Tests {
    
    func test_that_if_the_line_with_quotes_is_not_the_first_one_it_still_fucking_works() {
        let text = """
so i'm a line first
and then the "real" shit
and currently i fail
"""
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .doubleQuote, startingAt: 24)
        
        XCTAssertEqual(innerQuotedStringRange?.lowerBound, 34)
        XCTAssertEqual(innerQuotedStringRange?.upperBound, 38) 
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_innerQuotedString_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
emojis are sy🧑‍🌾️🧑‍🌾️mbols" that 🔫️🔫️🔫️ are longer" than 1 length
"""
        
        let innerQuotedStringRange = try? applyFuncBeingTested(on: text, using: .doubleQuote, startingAt: 9)
        
        XCTAssertEqual(innerQuotedStringRange?.lowerBound, 31)
        XCTAssertEqual(innerQuotedStringRange?.upperBound, 57) 
    }
    
}

