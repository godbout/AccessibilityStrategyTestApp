@testable import AccessibilityStrategy
import XCTest


// using the move f internally, so just a few tests needed here
// see cF for rest fo blah blah.
class ASUT_NM_cf_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.cf(to: character, on: element)
    }
    
}


// line
extension ASUT_NM_cf_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 19,
                end: 34
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "y", on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 24)
        XCTAssertEqual(returnedElement?.selectedLength, 37)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
     
}


// Both
extension ASUT_NM_cf_Tests {
    
    func test_that_in_normal_setting_it_selects_the_text_from_the_caret_to_the_character_found() {
        let text = "😂️😂️😂️😂️ gonna use cf on this sentence"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 13
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "s", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 3)
        XCTAssertEqual(returnedElement?.selectedLength, 18)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
    func test_that_if_the_character_is_not_found_then_it_does_nothing() {
        let text = """
gonna look
for a character
that is not there
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 2,
                start: 11,
                end: 17
            )
        )
        
        
        let returnedElement = applyMoveBeingTested(to: "z", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 14)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_cf_Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let text = """
cf on a multiline
should work
on a line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 39,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 3,
                start: 18,
                end: 30
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "w", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 18)
        XCTAssertEqual(returnedElement?.selectedLength, 8)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
