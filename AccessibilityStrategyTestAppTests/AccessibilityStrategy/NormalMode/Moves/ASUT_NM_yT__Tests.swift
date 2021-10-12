@testable import AccessibilityStrategy
import XCTest


// see other yt/f blah blah
class ASUT_NM_yT__Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.yT(to: character, on: element) 
    }
    
}


// line
extension ASUT_NM_yT__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothin🇫🇷️ happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 119,
            caretLocation: 116,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 5,
                start: 94,
                end: 119
            )!
        )

        let returnedElement = applyMoveBeingTested(to: "k", on: element)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "e nothin🇫🇷️ happened. that's how special it ")
        XCTAssertEqual(returnedElement?.caretLocation, 70)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}


// Both
extension ASUT_NM_yT__Tests {
    
    func test_that_in_normal_setting_it_copies_the_text_from_the_character_found_the_caret_and_move_the_caret_to_the_character_found() {
        let text = "gonna use yT on this sentence"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 1,
                start: 0,
                end: 29
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "T", on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), " on this sen")
        XCTAssertEqual(returnedElement?.caretLocation, 12)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 2,
                start: 11,
                end: 17
            )!
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
extension ASUT_NM_yT__Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let text = """
yT on a 📏️📏️📏️ multiline
should work 
on a line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 51,
            caretLocation: 25,
            selectedLength: 1,
            selectedText: "n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 3,
                start: 18,
                end: 28
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "y", on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "T on a 📏️📏️📏️ multili")
        XCTAssertEqual(returnedElement?.caretLocation, 1)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
