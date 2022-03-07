@testable import AccessibilityStrategy
import XCTest


// see F for blah blah
class ASUT_NM_f_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.f(times: count, to: character, on: element) 
    }
    
}


// line
extension ASUT_NM_f_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 11,
            selectedLength: 1,
            selectedText: "o",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 1,
                start: 0,
                end: 24
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "y", on: element)

        XCTAssertEqual(returnedElement.caretLocation, 60)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_NM_f_Tests {
    
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
        
        let returnedElement = applyMoveBeingTested(times: 3, to: "e", on: element)

        XCTAssertEqual(returnedElement.caretLocation, 47)
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
        
        let returnedElement = applyMoveBeingTested(times: 69, to: "i", on: element)

        XCTAssertEqual(returnedElement.caretLocation, 47)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// Both
extension ASUT_NM_f_Tests {
    
    func test_that_in_normal_setting_it_moves_the_caret_to_the_first_occurence_of_the_character_found_to_the_right() {
        let text = "check if f can 💩️💩️💩️ find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 35,
            caretLocation: 10,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 1,
                start: 0,
                end: 35
            )!
        )
        
        
        let returnedElement = applyMoveBeingTested(to: "i", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 26)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_character_is_not_found_then_the_caret_does_not_move() {
        let text = """
gonna look for a character that is not there
and the caret shouldn't move else pan pan cul cul
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 94,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "c",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 94,
                number: 3,
                start: 17,
                end: 27
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "z", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 22)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_it_is_on_a_character_and_we_look_for_the_same_character_it_moves_to_that_next_occurrence() {
        let text = """
it you're already on a z for example and wanna go to the next z it should work
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "z",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 2,
                start: 10,
                end: 25
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "z", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 62)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
