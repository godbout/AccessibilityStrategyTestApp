@testable import AccessibilityStrategy
import XCTest


// aQuotedString is innerQuotedString + checking the spaces before and/or after the innerQuotedString
// so a lot of the tests are already done there. here we test mostly what is specific to aQuotedString, which
// is the trailing and leading spaces story.
class FL_aQuotedString_Tests: XCTestCase {

    private func applyFuncBeingTested(on text: String, using quote: QuoteType, startingAt caretLocation: Int) throws -> Range<Int>? {
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: caretLocation)
        )
                
        return fileLine.aQuotedString(using: quote, startingAt: caretLocation)
    }
    
}


// Both
extension FL_aQuotedString_Tests {
    
    func test_that_if_there_is_no_quote_then_it_returns_nil() {
        let text = "yep no quote in here"
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .doubleQuote, startingAt: 2)
        
        XCTAssertNil(aQuotedStringRange)
    }
    
    func test_that_if_there_is_only_one_quote_then_it_returns_nil_also() throws {
        let text = "only one quote in 'there"
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .backtick, startingAt: 6)
        
        XCTAssertNil(aQuotedStringRange)
    }
        
    func test_that_if_there_is_no_space_after_the_upperBound_and_no_space_before_the_lowerBound_then_it_grabs_the_innerQuotedString_plus_the_quotes_themselves() {
        let text = "that's the most`basic`case of aQuotedString"
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .backtick, startingAt: 18)
        
        XCTAssertEqual(aQuotedStringRange?.lowerBound, 15)
        XCTAssertEqual(aQuotedStringRange?.count, 7) 
    }
    
    func test_that_if_there_is_a_trailing_space_after_the_upperBound_quote_then_it_is_grabbed_and_the_leading_space_is_ignored() {
        let text = "finally some serious 'gourmet' shit"
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .singleQuote, startingAt: 4)
        
        XCTAssertEqual(aQuotedStringRange?.lowerBound, 21)
        XCTAssertEqual(aQuotedStringRange?.count, 10) 
    }
    
    func test_that_if_there_is_no_trailing_space_after_the_upperBound_quote_which_means_there_is_a_new_word_or_WORD_instead_then_it_grabs_the_leading_space() {
        let text = "finally some serious 'gourmet'shit"
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .singleQuote, startingAt: 4)
        
        XCTAssertEqual(aQuotedStringRange?.lowerBound, 20)
        XCTAssertEqual(aQuotedStringRange?.count, 10) 
    }
    
    func test_that_if_there_are_multiple_trailing_spaces_after_the_upperBound_quote_then_they_are_grabbed_and_any_leading_space_is_ignored() {
        let text = "finally some serious `gourmet`           shit"
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .backtick, startingAt: 4)
        
        XCTAssertEqual(aQuotedStringRange?.lowerBound, 21)
        XCTAssertEqual(aQuotedStringRange?.count, 20) 
    }
    
    func test_that_if_there_is_no_trailing_space_after_the_upperBound_quote_which_means_there_is_a_new_word_or_WORD_instead_then_it_grabs_the_multiple_leading_spaces() {
        let text = "finally some serious                    'gourmet'shit"
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .singleQuote, startingAt: 4)
        
        XCTAssertEqual(aQuotedStringRange?.lowerBound, 20)
        XCTAssertEqual(aQuotedStringRange?.count, 29) 
    }
    
    func test_that_if_the_FileLine_starts_with_blanks_it_still_grabs_the_correct_range() {
        let text = "                  'gourmet'shit"
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .singleQuote, startingAt: 4)
        
        XCTAssertEqual(aQuotedStringRange?.lowerBound, 0)
        XCTAssertEqual(aQuotedStringRange?.count, 27) 
    }
        
    func test_that_if_the_FileLine_ends_with_blanks_it_still_grabs_the_correct_range() {
        let text = "hehe'gourmet'                    "
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .singleQuote, startingAt: 4)
        
        XCTAssertEqual(aQuotedStringRange?.lowerBound, 4)
        XCTAssertEqual(aQuotedStringRange?.count, 29) 
    }
    
    func test_just_to_be_sure_lol_with_an_empty_quotedString_surrounded_by_blanks_just_to_feel_i_am_doing_a_great_job() {
        let text = "         `              `              "
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .backtick, startingAt: 4)
        
        XCTAssertEqual(aQuotedStringRange?.lowerBound, 9)
        XCTAssertEqual(aQuotedStringRange?.count, 30) 
    }
    
}


// TextViews
// already tested in innerQuotedString, but one more to be sure
// cheap UTs.
extension FL_aQuotedString_Tests {
    
    // this test contains blanks
    func test_that_it_grabs_on_the_current_FileLine_and_does_not_spill_over() {
        let text = """
so this is some "multiline"       
      and the move should and its line
"""
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .doubleQuote, startingAt: 11)
        
        XCTAssertEqual(aQuotedStringRange?.lowerBound, 16)
        XCTAssertEqual(aQuotedStringRange?.count, 18) 
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_aQuotedString_Tests {
    
    func test_that_it_handles_emojis() throws {
        let text = """
emojis are sy🧑‍🌾️🧑‍🌾️mbols" that 🔫️🔫️🔫️ are longer" than 1 length
"""
        
        let aQuotedStringRange = try? applyFuncBeingTested(on: text, using: .doubleQuote, startingAt: 9)
        
        XCTAssertEqual(aQuotedStringRange?.lowerBound, 30)
        XCTAssertEqual(aQuotedStringRange?.count, 29) 
    }
    
}
