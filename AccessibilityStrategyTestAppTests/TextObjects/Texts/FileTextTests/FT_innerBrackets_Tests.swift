@testable import AccessibilityStrategy
import XCTest


// this is using nextUnmatched and previousUnmatched internally, which are already tested on their own
// so here we have just a few cases for extra care, and got the special cases for this move as usual
class FT_innerBrackets_Tests: XCTestCase {}


// Both
extension FT_innerBrackets_Tests {

    func test_that_if_there_is_no_bracket_then_it_returns_nil() {
        let text = "how dumb can you be LOL"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 23,
            caretLocation: 2,
            selectedLength: 1,
            selectedText: "w",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 23,
                number: 1,
                start: 0,
                end: 13
            )
        )
        
        XCTAssertNil(
            element.fileText.innerBrackets(using: "(", startingAt: 2)
        )
    }
    
    func test_that_if_there_is_only_one_bracket_then_it_returns_nil_also() {
        let text = "hey ho there's only one { in there!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "o",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 2,
                start: 7,
                end: 20
            )
        )
        
        XCTAssertNil(
            element.fileText.innerBrackets(using: "{", startingAt: 15)
        )
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_before_them_then_it_returns_nil() {
        let text = "still no gourmet [ shit for that ] one"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 38,
            caretLocation: 3,
            selectedLength: 1,
            selectedText: "l",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 1,
                start: 0,
                end: 9
            )
        )
        
        XCTAssertNil(
            element.fileText.innerBrackets(using: "[", startingAt: 3)
        )
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_after_them_then_it_returns_nil() {
        let text = "again no { gourmet shit } ducking hell"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 38,
            caretLocation: 33,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 4,
                start: 26,
                end: 38
            )
        )
        
        XCTAssertNil(
            element.fileText.innerBrackets(using: "{", startingAt: 33)
        )
    }
    
    func test_that_if_there_are_two_matched_brackets_and_the_caret_is_between_them_then_it_can_find_the_text() {
        let text = "ahhhhhh finally the { gourmet shit } motherfuckers"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 50,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "u",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 3,
                start: 20,
                end: 30
            )
        )
        
        guard let innerBracketsRange = element.fileText.innerBrackets(using: "{", startingAt: 24) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 20)
        XCTAssertEqual(innerBracketsRange.upperBound, 35)
    }
    
    func test_extra_cautiously_that_it_matches_the_right_pair_when_there_are_more_than_two_brackets() {
        let text = "hmm ok so we ( gonna try again ( some more and ) see i ) guess"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 62,
            caretLocation: 51,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 62,
                number: 5,
                start: 49,
                end: 57
            )
        )
        
        guard let innerBracketsRange = element.fileText.innerBrackets(using: "(", startingAt: 51) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 13)
        XCTAssertEqual(innerBracketsRange.upperBound, 55)
    }
    
    func test_that_if_there_are_several_pairs_of_bracket_and_the_caret_location_is_on_an_opening_bracket_on_the_inside_pair_it_can_find_the_correct_range() {
        let text = "yeah ok so ( that fails ( somehow ) that is bad! )"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 50,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "(",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 3,
                start: 24,
                end: 36
            )
        )
        
        guard let innerBracketsRange = element.fileText.innerBrackets(using: "(", startingAt: 24) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 24)
        XCTAssertEqual(innerBracketsRange.upperBound, 34)
    }
    
    func test_that_if_there_are_several_pairs_of_bracket_and_the_caret_location_is_on_a_closing_bracket_on_the_inside_pair_it_can_find_the_correct_range() {
        let text = "yeah ok so ( that fails ( somehow ) that is bad! )"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 50,
            caretLocation: 34,
            selectedLength: 1,
            selectedText: ")",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 3,
                start: 24,
                end: 36
            )
        )
        
        guard let innerBracketsRange = element.fileText.innerBrackets(using: "(", startingAt: 34) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 24)
        XCTAssertEqual(innerBracketsRange.upperBound, 34)
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
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 41,
            caretLocation: 27,
            selectedLength: 3,
            selectedText: "💩️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 41,
                number: 4,
                start: 23,
                end: 32
            )
        )
        
        guard let innerBracketsRange = element.fileText.innerBrackets(using: "[", startingAt: 27) else { return XCTFail() }
        
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
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 63,
            caretLocation: 48,
            selectedLength: 1,
            selectedText: "v",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 63,
                number: 6,
                start: 40,
                end: 52
            )
        )
        
        guard let innerBracketsRange = element.fileText.innerBrackets(using: "{", startingAt: 48) else { return XCTFail() }
        
        XCTAssertEqual(innerBracketsRange.lowerBound, 17)
        XCTAssertEqual(innerBracketsRange.upperBound, 59)
    }
    
}
