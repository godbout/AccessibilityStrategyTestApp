@testable import AccessibilityStrategy
import XCTest


class FT_nextUnmatched_Tests: XCTestCase {}


// Both
extension FT_nextUnmatched_Tests {
    
    func test_that_it_goes_to_the_next_unmatched_bracket_where_there_is_only_one() {
        let text = "ok so an easy test because i can't wrap } my head around the recursive func lol"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 79,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "y",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 79,
                number: 1,
                start: 0,
                end: 35
            )
        )
        
        let nextUnmatchedLocation = element.currentFileText.nextUnmatched("}", after: 11)
        
        XCTAssertEqual(nextUnmatchedLocation, 40)
    }
    
    func test_that_in_normal_setting_it_goes_to_the_next_unmatched_bracket() {
        let text = "hello{h}ell}"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 12,
            caretLocation: 1,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 12,
                number: 1,
                start: 0,
                end: 12
            )
        )
        
        let nextUnmatchedLocation = element.currentFileText.nextUnmatched("}", after: 2)
        
        XCTAssertEqual(nextUnmatchedLocation, 11)
    }
    
    func test_that_if_there_is_no_right_bracket_it_returns_nil() {
        let text = "no left brace in here move along"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "o",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 3,
                start: 17,
                end: 27
            )
        )
        
        let nextUnmatchedLocation = element.currentFileText.nextUnmatched("}", after: 19)
        
        XCTAssertNil(nextUnmatchedLocation)
    }
    
    func test_that_if_there_are_only_matched_brackets_it_returns_nil() {
        let text = "full of ( ) matched ( braces ) "
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 6,
            selectedLength: 1,
            selectedText: "f",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 1,
                start: 0,
                end: 12
            )
        )
        
        let nextUnmatchedLocation = element.currentFileText.nextUnmatched(")", after: 6)
        
        XCTAssertNil(nextUnmatchedLocation)
    }
      
    func test_that_if_the_caret_is_right_before_a_bracket_it_will_still_go_to_the_next_unmatched_one() {
        let text = """
so there's a ) here
and another ) here
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 39,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: ")",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 2,
                start: 11,
                end: 20
            )
        )
                
        let nextUnmatchedLocation = element.currentFileText.nextUnmatched(")", after: 13)

        XCTAssertEqual(nextUnmatchedLocation, 32)
    }
    
    func test_that_it_works_with_a_lot_of_brackets() {
        let text = "(   (    (   )   )     )"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 24,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: "(",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 24,
                number: 1,
                start: 0,
                end: 13
            )
        )
        
        let nextUnmatchedLocation = element.currentFileText.nextUnmatched(")", after: 0)

        XCTAssertEqual(nextUnmatchedLocation, 23)
    }
    
    func test_that_in_normal_cases_it_works_hehe() {
        let text = "a couple of ( (( ))))  ) O_o"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "(",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 2,
                start: 12,
                end: 25
            )
        )
        
        let nextUnmatchedLocation = element.currentFileText.nextUnmatched(")", after: 14)
        
        XCTAssertEqual(nextUnmatchedLocation, 18)
    }
    
    func test_another_complicated_one_to_see_if_the_algorithm_works() {
        let text = "{{{          }}         {{{{ }}}}}}}}"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 37,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )
        )
                
        let nextUnmatchedLocation = element.currentFileText.nextUnmatched("}", after: 20)
        
        XCTAssertEqual(nextUnmatchedLocation, 33)
    }
    
    func test_that_if_the_text_is_empty_it_returns_nil() {
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
        
        let nextUnmatchedLocation = element.currentFileText.nextUnmatched("}", after: 0)
        
        XCTAssertNil(nextUnmatchedLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_nextUnmatched_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emyeah 🤨️{🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't care about😂️🤨️🤨️🤨️ the len)gth but 🦋️ the move"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 107,
            caretLocation: 5,
            selectedLength: 1,
            selectedText: "h",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 107,
                number: 1,
                start: 0,
                end: 10
            )
        )
        
        let nextUnmatchedLocation = element.currentFileText.nextUnmatched(")", after: 6)
        
        XCTAssertEqual(nextUnmatchedLocation, 86)
    }
    
}
