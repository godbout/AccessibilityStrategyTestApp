@testable import AccessibilityStrategy
import XCTest


// this is using nextUnmatched and previousUnmatched internally, which are already tested on their own
// so here we have just a few cases for extra care, and got the special cases for this move as usual
class FT_innerBrackets_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, using bracket: Character, startingAt caretLocation: Int) -> Range<Int>? {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerBrackets(using: bracket, startingAt: caretLocation)
    }
       
}
    

// Both
extension FT_innerBrackets_Tests {

    func test_that_if_there_is_no_bracket_then_it_returns_nil() {
        let text = "how dumb can you be LOL"
        
        let innerBracketsRange = applyFuncBeingTested(on: text, using: "{", startingAt: 2)
        
        XCTAssertNil(innerBracketsRange)
    }
    
    func test_that_if_there_is_only_one_bracket_then_it_returns_nil_also() {
        let text = "hey ho there's only one { in there!"
        
        let innerBracketsRange = applyFuncBeingTested(on: text, using: "{", startingAt: 15)
        
        XCTAssertNil(innerBracketsRange)
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_before_them_then_it_returns_nil() {
        let text = "still no gourmet [ shit for that ] one"
        
        let innerBracketsRange = applyFuncBeingTested(on: text, using: "[", startingAt: 3)
        
        XCTAssertNil(innerBracketsRange)
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_after_them_then_it_returns_nil() {
        let text = "again no { gourmet shit } ducking hell"
        
        let innerBracketsRange = applyFuncBeingTested(on: text, using: "{", startingAt: 33)
        
        XCTAssertNil(innerBracketsRange)
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_between_them_then_it_can_find_the_text() {
        let text = "ahhhhhh finally the { gourmet shit } motherfuckers"
        
        let innerBracketsRange = applyFuncBeingTested(on: text, using: "{", startingAt: 24)
        
        XCTAssertEqual(innerBracketsRange?.lowerBound, 21)
        XCTAssertEqual(innerBracketsRange?.upperBound, 35)
    }
    
    func test_extra_cautiously_that_it_matches_the_right_pair_when_there_are_more_than_two_brackets() {
        let text = "hmm ok so we ( gonna try again ( some more and ) see i ) guess"
        
        let innerBracketsRange = applyFuncBeingTested(on: text, using: "(", startingAt: 51)
        
        XCTAssertEqual(innerBracketsRange?.lowerBound, 14)
        XCTAssertEqual(innerBracketsRange?.upperBound, 55)
    }
    
    func test_that_if_there_are_several_pairs_of_bracket_and_the_caret_location_is_on_an_opening_bracket_on_the_inside_pair_it_can_find_the_correct_range() {
        let text = "yeah ok so ( that fails ( somehow ) that is bad! )"
        
        let innerBracketsRange = applyFuncBeingTested(on: text, using: "(", startingAt: 24)
        
        XCTAssertEqual(innerBracketsRange?.lowerBound, 25)
        XCTAssertEqual(innerBracketsRange?.upperBound, 34)
    }
    
    func test_that_if_there_are_several_pairs_of_bracket_and_the_caret_location_is_on_a_closing_bracket_on_the_inside_pair_it_can_find_the_correct_range() {
        let text = "yeah ok so ( that fails ( somehow ) that is bad! )"
        
        let innerBracketsRange = applyFuncBeingTested(on: text, using: "(", startingAt: 34)
        
        XCTAssertEqual(innerBracketsRange?.lowerBound, 25)
        XCTAssertEqual(innerBracketsRange?.upperBound, 34)
    }
   
}


// TextViews
extension FT_innerBrackets_Tests {

    func test_that_it_works_when_the_brackets_are_not_on_the_same_line() {
        let text = """
var array = [
    😂️,
    💩️,
    🐶️
]
"""
        
        let innerBracketsRange = applyFuncBeingTested(on: text, using: "[", startingAt: 27)
        
        XCTAssertEqual(innerBracketsRange?.lowerBound, 13)
        XCTAssertEqual(innerBracketsRange?.upperBound, 40)
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
        
        let innerBracketsRange = applyFuncBeingTested(on: text, using: "{", startingAt: 48)
        
        XCTAssertEqual(innerBracketsRange?.lowerBound, 18)
        XCTAssertEqual(innerBracketsRange?.upperBound, 59)
    }
    
}
