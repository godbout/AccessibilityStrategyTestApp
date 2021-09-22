@testable import AccessibilityStrategy
import XCTest


// this is using nextUnmatched and previousUnmatched internally, which are already tested on their own
// so here we have just a few cases for extra care, and got the special cases for this move as usual
class innerBracketsTests: TextEngineBaseTests {}


// Both
extension innerBracketsTests {

    func test_that_if_there_is_no_bracket_then_it_returns_nil() {
        let text = "how dumb can you be LOL"
        
        XCTAssertNil(
            textEngine.innerBrackets(using: "(", startingAt: 2, in: TextEngineText(from: text))
        )
    }
    
    func test_that_if_there_is_only_one_bracket_then_it_returns_nil_also() {
        let text = "hey ho there's only one { in there!"
        
        XCTAssertNil(
            textEngine.innerBrackets(using: "{", startingAt: 15, in: TextEngineText(from: text))
        )
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_before_them_then_it_returns_nil() {
        let text = "still no gourmet [ shit for that ] one"
        
        XCTAssertNil(
            textEngine.innerBrackets(using: "[", startingAt: 3, in: TextEngineText(from: text))
        )
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_after_them_then_it_returns_nil() {
        let text = "again no { gourmet shit } ducking hell"
        
        XCTAssertNil(
            textEngine.innerBrackets(using: "{", startingAt: 33, in: TextEngineText(from: text))
        )
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_between_them_then_it_can_find_the_text() {
        let text = "ahhhhhh finally the { gourmet shit } motherfuckers"
        
        guard let innerBracketsRange = textEngine.innerBrackets(using: "{", startingAt: 24, in: TextEngineText(from: text)) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 20)
        XCTAssertEqual(innerBracketsRange.upperBound, 35)
    }
    
    func test_extra_cautiously_that_it_matches_the_right_pair_when_there_are_more_than_two_brackets() {
        let text = "hmm ok so we ( gonna try again ( some more and ) see i ) guess"
        
        guard let innerBracketsRange = textEngine.innerBrackets(using: "(", startingAt: 51, in: TextEngineText(from: text)) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 13)
        XCTAssertEqual(innerBracketsRange.upperBound, 55)
    }
    
    func test_that_if_there_are_several_pairs_of_bracket_and_the_caret_location_is_on_an_opening_bracket_on_the_inside_pair_it_can_find_the_correct_range() {
        let text = "yeah ok so ( that fails ( somehow ) that is bad! )"
        
        guard let innerBracketsRange = textEngine.innerBrackets(using: "(", startingAt: 24, in: TextEngineText(from: text)) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 24)
        XCTAssertEqual(innerBracketsRange.upperBound, 34)
    }
    
    func test_that_if_there_are_several_pairs_of_bracket_and_the_caret_location_is_on_a_closing_bracket_on_the_inside_pair_it_can_find_the_correct_range() {
        let text = "yeah ok so ( that fails ( somehow ) that is bad! )"
        
        guard let innerBracketsRange = textEngine.innerBrackets(using: "(", startingAt: 34, in: TextEngineText(from: text)) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 24)
        XCTAssertEqual(innerBracketsRange.upperBound, 34)
    }
   
}


// TextViews
extension innerBracketsTests {

    func test_that_it_works_when_the_brackets_are_not_on_the_same_line() {
        let text = """
var array = [
    😂️,
    💩️,
    🐶️
]
"""
        
        guard let innerBracketsRange = textEngine.innerBrackets(using: "[", startingAt: 27, in: TextEngineText(from: text)) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 12)
        XCTAssertEqual(innerBracketsRange.upperBound, 40)
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
        
        guard let innerBracketsRange = textEngine.innerBrackets(using: "{", startingAt: 48, in: TextEngineText(from: text)) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 17)
        XCTAssertEqual(innerBracketsRange.upperBound, 59)
    }
    
}
