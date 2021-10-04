@testable import AccessibilityStrategy
import XCTest


// more tests are done on the FileLine level
// the FileLine funcs tests make sure it works properly if we are
// at last character, out of bound, on the character we're searching, etc...
// here the two tests relevant are:
// 1. can find the character, then getting the right location
// 2. cannot find the character, then not moving
class ASUT_NM_F__Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.F(to: character, on: element) 
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
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 7,
                start: 97,
                end: 115
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "k", on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 69)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
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
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 1,
                start: 0,
                end: 35
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "k", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 4)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
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
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 3,
                start: 17,
                end: 27
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "z", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 22)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
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
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 6,
                start: 48,
                end: 52
            )
        )
        
        let returnedElement = applyMoveBeingTested(to: "y", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 48)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
