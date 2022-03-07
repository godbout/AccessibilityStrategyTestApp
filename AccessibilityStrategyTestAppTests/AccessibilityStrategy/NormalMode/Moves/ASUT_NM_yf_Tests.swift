@testable import AccessibilityStrategy
import XCTest
import Common


// see yt for blah blah
class ASUT_NM_yf_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, with character: Character, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yf(times: count, to: character, on: element, &vimEngineState)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 3,
                start: 62,
                end: 119
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(with: "w", on: element, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "🇫🇷️ happened. that's how")
        XCTAssertEqual(returnedElement.caretLocation, 78)
        XCTAssertEqual(returnedElement.selectedLength, 5)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// Bip, copy deletion and LYS
extension ASUT_NM_yf_Tests {
    
    func test_that_when_it_finds_the_stuff_it_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion() {
        let text = "gonna use yf 🥮️ this sentence"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 13
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(with: "s", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "e yf 🥮️ this")
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
                end: 17
            )!
        )
        
        copyToClipboard(text: "404 character not found")
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(with: "z", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "404 character not found")
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .linewise)
    }
    
}


// count
extension ASUT_NM_yf_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "we gonna look for a third letter 💌️💌️💌️ rather than a first one"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 66,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "d",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 1,
                start: 0,
                end: 66
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(times: 3, with: "e", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "d letter 💌️💌️💌️ rathe")
        XCTAssertEqual(returnedElement.caretLocation, 24)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_and_therefore_character_is_not_found_then_it_does_not_move() {
        let text = "now the count is gonna be too high so we can't 🍔️🍔️🍔️ find the fucking character"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 83,
            caretLocation: 47,
            selectedLength: 3,
            selectedText: "🍔️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 83,
                number: 1,
                start: 0,
                end: 62
            )!
        )
        
        copyToClipboard(text: "404 character not found")
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(times: 69, with: "i", on: element, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "404 character not found")
        XCTAssertEqual(returnedElement.caretLocation, 47)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// Both
extension ASUT_NM_yf_Tests {
    
    // on yF and yT move, yf and yt don't
    func test_that_when_it_finds_the_stuff_it_actually_does_not_move_LOL() {
        let text = "gonna use yf 🥮️ this sentence"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 13
            )!
        )
        
        var state = VimEngineState()
        let returnedElement = applyMoveBeingTested(with: "s", on: element, &state)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_when_it_does_not_find_the_stuff_it_does_not_move() {
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
        
        copyToClipboard(text: "404 character not found")
        var state = VimEngineState()
        let returnedElement = applyMoveBeingTested(with: "z", on: element, &state)
        
        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_yf_Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline_and_sets_the_LastYankStyle_to_Characterwise() {
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 40,
                number: 1,
                start: 0,
                end: 8
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(with: "m", on: element, &state)
        
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "n a m")
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
