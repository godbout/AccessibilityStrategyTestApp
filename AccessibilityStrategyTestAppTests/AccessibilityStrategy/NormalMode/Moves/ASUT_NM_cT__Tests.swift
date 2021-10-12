@testable import AccessibilityStrategy
import XCTest


// cF for blah blah
class ASNM_cT__Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.cT(to: character, on: element)
    }
    
}


// line
extension ASNM_cT__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 60,
            selectedLength: 1,
            selectedText: "y",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 3,
                start: 49,
                end: 62
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "l", on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 48)
        XCTAssertEqual(returnedElement?.selectedLength, 12)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
     
}


// Both
extension ASNM_cT__Tests {
    
    func test_that_in_normal_setting_it_selects_from_after_the_character_found_to_the_caret() {
        let text = "gonna use cT on that sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 29,
            caretLocation: 25,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 1,
                start: 0,
                end: 29
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "T", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 12)
        XCTAssertEqual(returnedElement?.selectedLength, 13)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 2,
                start: 11,
                end: 17
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "z", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 14)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// TextViews
extension ASNM_cT__Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let text = """
dT on a multiline
should w🔨️🔨️or🔨️k
on a line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 48,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "k",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 2,
                start: 18,
                end: 39
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "w", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 26)
        XCTAssertEqual(returnedElement?.selectedLength, 11)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
