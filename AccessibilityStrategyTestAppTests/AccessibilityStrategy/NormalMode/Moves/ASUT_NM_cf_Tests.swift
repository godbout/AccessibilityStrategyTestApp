@testable import AccessibilityStrategy
import XCTest


// using the move f internally, so just a few tests needed here
// see cF for rest fo blah blah.
class ASUT_NM_cf_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, on element: AccessibilityTextElement?, _ bipped: inout Bool) -> AccessibilityTextElement? {
        return asNormalMode.cf(times: count, to: character, on: element, pgR: false, &bipped)
    }
    
}


// copy deleted text
extension ASUT_NM_cf_Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
        let text = "😂️😂️😂️😂️ gonna use cf on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var bipped = false
        _ = applyMoveBeingTested(to: "s", on: element, &bipped)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "😂️😂️😂️ gonna us")
    }
    
}


// bipped
extension ASUT_NM_cf_Tests {
    
    func test_that_it_does_not_Bip_when_it_can_find() {
        let text = "😂️😂️😂️😂️ gonna use cf on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
       
        var bipped = false
        _ = applyMoveBeingTested(to: "s", on: element, &bipped)
        
        XCTAssertFalse(bipped)
    }
        
    func test_that_it_Bips_when_it_cannot_find() {
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
        
        var bipped = false 
        _ = applyMoveBeingTested(to: "z", on: element, &bipped)
        
        XCTAssertTrue(bipped)
    }
    
}


// count
extension ASUT_NM_cf_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "here we gonna delete up to 🕑️ characters rather than 🦴️!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 58,
            caretLocation: 19,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 1,
                start: 0,
                end: 58
            )!
        )
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(times: 2, to: "e", on: element, &bipped)
        
        XCTAssertEqual(returnedElement?.caretLocation, 19)
        XCTAssertEqual(returnedElement?.selectedLength, 28)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}


// Both
extension ASUT_NM_cf_Tests {
    
    func test_that_in_normal_setting_it_selects_the_text_from_the_caret_to_the_character_found() {
        let text = "😂️😂️😂️😂️ gonna use cf on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(to: "s", on: element, &bipped)
        
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 2,
                start: 11,
                end: 17
            )!
        )
        
        var bipped = false 
        let returnedElement = applyMoveBeingTested(to: "z", on: element, &bipped)
        
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 2,
                start: 18,
                end: 30
            )!
        )
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(to: "w", on: element, &bipped)
        
        XCTAssertEqual(returnedElement?.caretLocation, 18)
        XCTAssertEqual(returnedElement?.selectedLength, 8)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
