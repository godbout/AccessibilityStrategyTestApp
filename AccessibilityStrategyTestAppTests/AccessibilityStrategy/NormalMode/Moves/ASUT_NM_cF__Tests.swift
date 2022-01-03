@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_cF__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, on element: AccessibilityTextElement?, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement? {
        return asNormalMode.cF(times: count, to: character, on: element, pgR: false, &vimEngineState) 
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_cF__Tests {
    
    func test_that_when_it_finds_the_stuff_it_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion() {
        let text = "gonna use cF on that sentence"
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
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastYankStyle: .linewise, lastMoveBipped: true)
        _ = applyMoveBeingTested(to: "F", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "F on that sent")
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
    
    func test_that_when_it_does_not_find_the_stuff_it_Bips_and_does_not_change_the_LastYankingStyle_and_does_not_copy_anything() {
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
                end: 27
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastYankStyle: .linewise, lastMoveBipped: false)
        _ = applyMoveBeingTested(to: "z", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .linewise)
    }
    
}


// count
extension ASUT_NM_cF__Tests {
    
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
        
        var state = VimEngineState()
        let returnedElement = applyMoveBeingTested(times: 2, to: "e", on: element, &state)
        
        XCTAssertEqual(returnedElement?.caretLocation, 15)
        XCTAssertEqual(returnedElement?.selectedLength, 4)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}


// Both
extension ASUT_NM_cF__Tests {
    
    func test_that_in_normal_setting_it_selects_from_the_character_found_to_the_caret() {
        let text = "gonna use cF on that sentence"
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
        
        var state = VimEngineState()
        let returnedElement = applyMoveBeingTested(to: "F", on: element, &state)
        
        XCTAssertEqual(returnedElement?.caretLocation, 11)
        XCTAssertEqual(returnedElement?.selectedLength, 14)
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
                end: 27
            )!
        )
        
        var state = VimEngineState() 
        let returnedElement = applyMoveBeingTested(to: "z", on: element, &state)
        
        XCTAssertEqual(returnedElement?.caretLocation, 14)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_cF__Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let text = """
cF on a multiline
should work
on a 📏️📏️ line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 46,
            caretLocation: 45,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 46,
                number: 3,
                start: 30,
                end: 46
            )!
        )
        
        var state = VimEngineState()
        let returnedElement = applyMoveBeingTested(to: "o", on: element, &state)
        
        XCTAssertEqual(returnedElement?.caretLocation, 30)
        XCTAssertEqual(returnedElement?.selectedLength, 15)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
