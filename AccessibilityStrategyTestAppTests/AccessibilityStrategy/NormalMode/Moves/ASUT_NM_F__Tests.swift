@testable import AccessibilityStrategy
import XCTest


// more tests are done on the FileLine level
// the FileLine funcs tests make sure it works properly if we are
// at last character, out of bound, on the character we're searching, etc...
// here the two tests relevant are:
// 1. can find the character, then getting the right location
// 2. cannot find the character, then not moving
class ASUT_NM_F__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.F(times: count, to: character, on: element) 
    }
}


// line
extension ASUT_NM_F__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 106,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<115,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 7,
                start: 97,
                end: 115
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "k", on: element)

        XCTAssertEqual(returnedElement.caretLocation, 69)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_NM_F__Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "we gonna look for a third letter 💌️💌️💌️ rather than a first one"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 66,
            caretLocation: 53,
            selectedLength: 1,
            selectedText: "n",
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

        XCTAssertEqual(returnedElement.caretLocation, 27)
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
extension ASUT_NM_F__Tests {
    
    func test_that_in_normal_setting_it_moves_the_caret_to_the_first_occurence_of_the_character_found_to_the_left() {
        let text = "check 💣️💣️💣️ if F can find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 35,
            caretLocation: 19,
            selectedLength: 1,
            selectedText: "F",
            fullyVisibleArea: 0..<35,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 1,
                start: 0,
                end: 35
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "k", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 4)
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
extension ASUT_NM_F__Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let text = """
fFtT should
work on multilines
without crashing
yeah
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 52,
            caretLocation: 51,
            selectedLength: 1,
            selectedText: "h",
            fullyVisibleArea: 0..<52,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 6,
                start: 48,
                end: 52
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "y", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 48)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
