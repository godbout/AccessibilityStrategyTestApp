@testable import AccessibilityStrategy
import XCTest


class FT_aBlock_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, using bracket: Character, startingAt caretLocation: Int) -> Range<Int>? {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aBlock(using: bracket, startingAt: caretLocation)
    }
        
}


// Both
extension FT_aBlock_Tests {

    func test_that_if_there_is_no_bracket_then_it_returns_nil() {
        let text = "how dumb can you be LOL"
        
        let aBlockRange = applyFuncBeingTested(on: text, using: "{", startingAt: 2)
        
        XCTAssertNil(aBlockRange)
    }
    
    func test_that_if_there_is_only_one_bracket_then_it_returns_nil_also() {
        let text = "hey ho there's only one { in there!"
        
        let aBlockRange = applyFuncBeingTested(on: text, using: "{", startingAt: 15)
        
        XCTAssertNil(aBlockRange)
    }

    
    // see innerBlock for blah blah (new way in Vim)
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_before_them_and_there_is_no_previous_unmatched_bracket_then_it_can_find_the_text() {
        let text = "still no gourmet [ shit for that ] one"
        
        let aBlockRange = applyFuncBeingTested(on: text, using: .leftBracket, startingAt: 3)
        
        XCTAssertEqual(aBlockRange?.lowerBound, 17)
        XCTAssertEqual(aBlockRange?.count, 17)
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_after_them_then_it_returns_nil() {
        let text = "again no { gourmet shit } ducking hell"
        
        let aBlockRange = applyFuncBeingTested(on: text, using: "{", startingAt: 33)
        
        XCTAssertNil(aBlockRange)
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_between_them_then_it_can_find_aBlock() {
        let text = "ahhhhhh finally the { gourmet shit } motherfuckers"
        
        let aBlockRange = applyFuncBeingTested(on: text, using: "{", startingAt: 24)
        
        XCTAssertEqual(aBlockRange?.lowerBound, 20)
        XCTAssertEqual(aBlockRange?.upperBound, 36)
    }
    
    func test_extra_cautiously_that_it_matches_the_right_pair_when_there_are_more_than_two_brackets() {
        let text = "hmm ok so we ( gonna try again ( some more and ) see i ) guess"
        
        let aBlockRange = applyFuncBeingTested(on: text, using: "(", startingAt: 51)
        
        XCTAssertEqual(aBlockRange?.lowerBound, 13)
        XCTAssertEqual(aBlockRange?.upperBound, 56)
    }
    
    func test_that_if_there_are_several_pairs_of_bracket_and_the_caret_location_is_on_an_opening_bracket_on_the_inside_pair_it_can_find_the_correct_range() {
        let text = "yeah ok so ( that fails ( somehow ) that is bad! )"
        
        let aBlockRange = applyFuncBeingTested(on: text, using: "(", startingAt: 24)
        
        XCTAssertEqual(aBlockRange?.lowerBound, 24)
        XCTAssertEqual(aBlockRange?.upperBound, 35)
    }
    
    func test_that_if_there_are_several_pairs_of_bracket_and_the_caret_location_is_on_a_closing_bracket_on_the_inside_pair_it_can_find_the_correct_range() {
        let text = "yeah ok so ( that fails ( somehow ) that is bad! )"
        
        let aBlockRange = applyFuncBeingTested(on: text, using: "(", startingAt: 34)
        
        XCTAssertEqual(aBlockRange?.lowerBound, 24)
        XCTAssertEqual(aBlockRange?.upperBound, 35)
    }
   
}


// TextViews
extension FT_aBlock_Tests {

    func test_that_it_works_when_the_brackets_are_not_on_the_same_line() {
        let text = """
var array = [
    😂️,
    💩️,
    🐶️
]
"""
        
        let aBlockRange = applyFuncBeingTested(on: text, using: "[", startingAt: 27)
        
        XCTAssertEqual(aBlockRange?.lowerBound, 12)
        XCTAssertEqual(aBlockRange?.upperBound, 41)
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
        let aBlockRange = applyFuncBeingTested(on: text, using: "{", startingAt: 48)
        
        XCTAssertEqual(aBlockRange?.lowerBound, 17)
        XCTAssertEqual(aBlockRange?.upperBound, 60)
    }
    
}
