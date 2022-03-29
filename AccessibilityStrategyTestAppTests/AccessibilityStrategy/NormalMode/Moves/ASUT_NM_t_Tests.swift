@testable import AccessibilityStrategy
import XCTest


// see F for blah blah
class ASUT_NM_t_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.t(times: count, to: character, on: element) 
    }
    
}


// line
extension ASUT_NM_t_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 7,
            selectedLength: 1,
            selectedText: "v",
            fullyVisibleArea: 0..<115,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 1,
                start: 0,
                end: 27
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "y", on: element)

        XCTAssertEqual(returnedElement.caretLocation, 59)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_NM_t_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "we gonna look for a third letter 💌️💌️💌️ rather than a first one"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 66,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "d",
            fullyVisibleArea: 0..<66,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 1,
                start: 0,
                end: 66
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 3, to: "e", on: element)

        XCTAssertEqual(returnedElement.caretLocation, 46)
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
            fullyVisibleArea: 0..<83,
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
extension ASUT_NM_t_Tests {
    
    func test_that_in_normal_setting_it_moves_the_caret_before_the_first_occurence_of_the_character_found_to_the_right() {
        let text = "check if t can find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 10,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )        
        
        let returnedElement = applyMoveBeingTested(to: "i", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 15)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_character_is_not_found_then_the_caret_does_not_move() {
        let text = """
gonna look
for a character
that is not there
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "c",
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
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
    
}


// TextViews
extension ASUT_NM_t_Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let text = """
fFtT should
work on multilines
without cr💣️💣️💣️ashing
yeah
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 52,
            caretLocation: 31,
            selectedLength: 1,
            selectedText: "w",
            fullyVisibleArea: 0..<52,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 4,
                start: 31,
                end: 39
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "a", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 47)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
