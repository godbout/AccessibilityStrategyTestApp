@testable import AccessibilityStrategy
import XCTest


class FT_previousUnmatched_Tests: XCTestCase {}


// Both
extension FT_previousUnmatched_Tests {
        
    func test_that_it_can_move_to_a_lonely_bracket() {
        let text = "that's a lonely { right here "
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 29,
            caretLocation: 25,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 1,
                start: 0,
                end: 29
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("{", before: 25)
        
        XCTAssertEqual(previousUnmatchedLocation, 16)
    }
    
    func test_that_in_normal_setting_it_goes_to_the_previous_unmatched_bracket() {
        let text = "that one's { gonna sting { lo"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "o",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 3,
                start: 19,
                end: 29
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("{", before: 29)
        
        XCTAssertEqual(previousUnmatchedLocation, 25)
    }
    
    func test_that_it_skips_matched_brackets() {
        let text = "a { tougher { one } i believe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 3,
                start: 22,
                end: 29
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("{", before: 28)
        
        XCTAssertEqual(previousUnmatchedLocation, 2)
    }
    
    func test_that_if_it_cannot_find_a_previous_unmatched_bracket_it_returns_nil() {
        let text = "no left brace in here move along"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 3,
                start: 17,
                end: 27
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("(", before: 20)
        
        XCTAssertNil(previousUnmatchedLocation)
    }
    
    func test_that_if_there_are_only_matched_brackets_it_returns_nil() {
        let text = "full of ( ) matched ( braces )"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: ")",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 3,
                start: 20,
                end: 30
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("(", before: 30)
        
        XCTAssertNil(previousUnmatchedLocation)
    }
    
    func test_that_if_the_caret_is_right_before_a_bracket_it_will_still_go_to_the_previous_one() {
        let text = """
caret just ( before
the second brace ( yes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 4,
                start: 31,
                end: 42
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("(", before: 37)
        
        XCTAssertEqual(previousUnmatchedLocation, 11)
    }
    
    func test_that_if_the_caret_is_right_after_a_left_bracket_it_still_goes_to_that_bracket() {
        let text = """
caret
is right after
the { second
brace { yes
again
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 51,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 5,
                start: 34,
                end: 46
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("{", before: 41)
        
        XCTAssertEqual(previousUnmatchedLocation, 40)
    }
    
    func test_that_it_works_with_a_lot_of_brackets_lol() {
        let text = "(   (    (   )   )     "
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 23,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 23,
                number: 2,
                start: 13,
                end: 23
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("(", before: 23)
        
        XCTAssertEqual(previousUnmatchedLocation, 0)
    }
    
    func test_that_it_does_not_explode_with_string_out_of_bounds_like_before() {
        let text = "that one's { gonna s}ting { lo"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "l",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 3,
                start: 21,
                end: 30
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("{", before: 28)
        
        XCTAssertEqual(previousUnmatchedLocation, 26)
    }
    
    func test_whatever_to_sleep_better_at_night() {
        let text = " a couple of ( ( )"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 18,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "(",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 18,
                number: 1,
                start: 0,
                end: 18
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("(", before: 15)
        
        XCTAssertEqual(previousUnmatchedLocation, 13)
    }
    
    func test_again_that_in_normal_cases_it_works_hehe_because_of_multiple_past_failures() {
        let text = "a couple of ( (( ))))  ) O_o"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 19,
            selectedLength: 1,
            selectedText: ")",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 1,
                start: 0,
                end: 28
            )
        )
                
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("(", before: 19)
        
        XCTAssertEqual(previousUnmatchedLocation, 12)
    }
    
    func test_another_complicated_one_to_see_if_the_algorithm_works() {
        let text = "{{{          }         {{{{ }}}}}}}}"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 17,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 2,
                start: 13,
                end: 23
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("{", before: 17)
        
        XCTAssertEqual(previousUnmatchedLocation, 1)
    }
    
    func test_that_if_the_text_is_empty_it_returns_nil() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
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
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("{", before: 0)
        
        XCTAssertNil(previousUnmatchedLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_previousUnmatched_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emyeah 🤨️{🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't care about😂️🤨️🤨️🤨️ the length but 🦋️ the move"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 106,
            caretLocation: 104,
            selectedLength: 1,
            selectedText: "v",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 106,
                number: 9,
                start: 94,
                end: 106
            )
        )
        
        let previousUnmatchedLocation = element.currentFileText.previousUnmatched("{", before: 103)
        
        XCTAssertEqual(previousUnmatchedLocation, 10)
    }
    
}
