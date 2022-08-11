@testable import AccessibilityStrategy
import XCTest


// this is using nextUnmatched and previousUnmatched internally, which are already tested on their own
// so here we have just a few cases for extra care, and got the special cases for this move as usual
// 2022-08-12: tried to move the handling of special cases for multilines here so that we don't repeat some code
// for VM innerBlock but can't make sense of when to keep the linefeeds, when to discard etc. seems it depends on the moves
// themselves, so ultimately each move is gonna take care of itself.
class FT_innerBlock_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, using openingBlock: OpeningBlockType, startingAt caretLocation: Int) -> Range<Int>? {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerBlock(using: openingBlock, startingAt: caretLocation)
    }
       
}
    

// Both
extension FT_innerBlock_Tests {

    func test_that_if_there_is_no_bracket_then_it_returns_nil() {
        let text = "how dumb can you be LOL"
        
        let innerBlockRange = applyFuncBeingTested(on: text, using: .leftBrace, startingAt: 2)
        
        XCTAssertNil(innerBlockRange)
    }
    
    func test_that_if_there_is_only_one_bracket_then_it_returns_nil_also() {
        let text = "hey ho there's only one { in there!"
        
        let innerBlockRange = applyFuncBeingTested(on: text, using: .leftBrace, startingAt: 15)
        
        XCTAssertNil(innerBlockRange)
    }
    
    // NEW way. added in Vim in Aug 2021: https://github.com/vim/vim/commit/b9115da4bec5e6cfff69da85cc47c42dd67e42e4
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_before_them_and_there_is_no_previous_unmatched_bracket_then_it_can_find_the_text() {
        let text = "still no gourmet [ shit for that ] one"
        
        let innerBlockRange = applyFuncBeingTested(on: text, using: .leftBracket, startingAt: 3)
        
        XCTAssertEqual(innerBlockRange?.lowerBound, 18)
        XCTAssertEqual(innerBlockRange?.count, 15)
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_after_them_then_it_returns_nil() {
        let text = "again no { gourmet shit } ducking hell"
        
        let innerBlockRange = applyFuncBeingTested(on: text, using: .leftBrace, startingAt: 33)
        
        XCTAssertNil(innerBlockRange)
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_between_them_then_it_can_find_the_text() {
        let text = "ahhhhhh finally the { gourmet shit } motherfuckers"
        
        let innerBlockRange = applyFuncBeingTested(on: text, using: .leftBrace, startingAt: 24)
        
        XCTAssertEqual(innerBlockRange?.lowerBound, 21)
        XCTAssertEqual(innerBlockRange?.upperBound, 35)
    }
    
    func test_extra_cautiously_that_it_matches_the_right_pair_when_there_are_more_than_two_brackets() {
        let text = "hmm ok so we ( gonna try again ( some more and ) see i ) guess"
        
        let innerBlockRange = applyFuncBeingTested(on: text, using: .leftParenthesis, startingAt: 51)
        
        XCTAssertEqual(innerBlockRange?.lowerBound, 14)
        XCTAssertEqual(innerBlockRange?.upperBound, 55)
    }
    
    func test_that_if_there_are_several_pairs_of_bracket_and_the_caret_location_is_on_an_opening_bracket_on_the_inside_pair_it_can_find_the_correct_range() {
        let text = "yeah ok so ( that fails ( somehow ) that is bad! )"
        
        let innerBlockRange = applyFuncBeingTested(on: text, using: .leftParenthesis, startingAt: 24)
        
        XCTAssertEqual(innerBlockRange?.lowerBound, 25)
        XCTAssertEqual(innerBlockRange?.upperBound, 34)
    }
    
    func test_that_if_there_are_several_pairs_of_bracket_and_the_caret_location_is_on_a_closing_bracket_on_the_inside_pair_it_can_find_the_correct_range() {
        let text = "yeah ok so ( that fails ( somehow ) that is bad! )"
        
        let innerBlockRange = applyFuncBeingTested(on: text, using: .leftParenthesis, startingAt: 34)
        
        XCTAssertEqual(innerBlockRange?.lowerBound, 25)
        XCTAssertEqual(innerBlockRange?.upperBound, 34)
    }
   
}


// TextViews
extension FT_innerBlock_Tests {

    func test_that_it_works_when_the_brackets_are_not_on_the_same_line() {
        let text = """
var array = [
    😂️,
    💩️,
    🐶️
]
"""
        
        let innerBlockRange = applyFuncBeingTested(on: text, using: .leftBracket, startingAt: 27)
        
        XCTAssertEqual(innerBlockRange?.lowerBound, 13)
        XCTAssertEqual(innerBlockRange?.upperBound, 40)
    }
    
    // currently we don't skip brackets within quoted strings, but later we might have too.
    // Vim itself ignores them.
    // so currently this test "passes", but ultimately it doesn't behave like Vim.
    func test_that_currently_we_do_not_skip_brackets_that_are_within_quoted_strings() {
        let text = """
func something() {
        var 😂️ = ""
        var 🤣️ = "}"
}
"""
        
        let innerBlockRange = applyFuncBeingTested(on: text, using: .leftBrace, startingAt: 48)
        
        XCTAssertEqual(innerBlockRange?.lowerBound, 18)
        XCTAssertEqual(innerBlockRange?.upperBound, 59)
    }
    
}
