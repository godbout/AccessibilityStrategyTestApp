@testable import AccessibilityStrategy
import XCTest


// see yt for blah blah
class ASUT_NM_yf_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.yf(to: character, on: element) 
    }
    
}


// line
extension ASUT_NM_yf_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothin🇫🇷️ happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 119,
            caretLocation: 78,
            selectedLength: 26,
            selectedText: "🇫🇷️ happened. that's how",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 3,
                start: 62,
                end: 119
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "w", on: element)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "🇫🇷️ happened. that's how")
        XCTAssertEqual(returnedElement?.caretLocation, 78)
        XCTAssertEqual(returnedElement?.selectedLength, 5)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}


// Both
extension ASUT_NM_yf_Tests {
    
    func test_that_in_normal_setting_it_copies_the_text_from_the_caret_to_the_character_found() {
        let text = "gonna use yf 🥮️ this sentence"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 13
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "s", on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "e yf 🥮️ this")
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
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
        
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("404 character not found", forType: .string)
        
        let returnedElement = applyMoveBeingTested(to: "z", on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "404 character not found")
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_yf_Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let text = """
yf on a multiline
should work 
on a line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 40,
            caretLocation: 4,
            selectedLength: 1,
            selectedText: "n",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 40,
                number: 1,
                start: 0,
                end: 8
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "m", on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "n a m")
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
