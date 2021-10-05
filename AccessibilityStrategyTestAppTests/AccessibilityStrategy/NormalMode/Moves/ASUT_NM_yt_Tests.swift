@testable import AccessibilityStrategy
import XCTest


// yt uses t internally, which is already tested.
// just some tests here to confirm the NSPasteboard got filled
// we don't bother with caretLocation and stuff coz they're completely untouched
class ASUT_NM_yt_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.yt(to: character, on: element) 
    }
    
}


// line
extension ASUT_NM_yt_Tests {
    
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

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "🇫🇷️ happened. that's ho")
        XCTAssertEqual(returnedElement?.caretLocation, 78)
        XCTAssertEqual(returnedElement?.selectedLength, 5)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}


// Both
extension ASUT_NM_yt_Tests {
    
    func test_that_in_normal_setting_it_copies_the_text_from_the_caret_to_before_the_character_found() {
        let text = "gonna use yt on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 29,
            caretLocation: 8,
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
        
        let returnedElement = applyMoveBeingTested(to: "s", on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "e yt on thi")
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
extension ASUT_NM_yt_Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let text = """
yt on a 🍌️ multiline
should work 
on a line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 4,
            selectedLength: 1,
            selectedText: "n",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 12
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "m", on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "n a 🍌️ ")
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
