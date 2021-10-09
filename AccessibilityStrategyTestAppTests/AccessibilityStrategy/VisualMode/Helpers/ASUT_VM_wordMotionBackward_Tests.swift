@testable import AccessibilityStrategy
import XCTest


// see wordMotionForward for blah blah
// wordMotionBackward called by b, B, ge, gE.
class ASUT_VM_wordMotionBackward_Tests: ASVM_BaseTests {

    private func applyMove(on element: AccessibilityTextElement?, using wordMotionBackwardFunction: (Int) -> Int?) -> AccessibilityTextElement? {
        return asVisualMode.wordMotionBackward(on: element, using: wordMotionBackwardFunction)
    }
    
}


// Both
extension ASUT_VM_wordMotionBackward_Tests {
    
    func test_that_if_the_head_is_after_the_anchor_it_reduces_the_selected_length_up_to_the_new_head_location_related_to_the_word_motion_move() {
        let text = "gonna start with text moves in Visual Mode"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 10,
            selectedLength: 25,
            selectedText: "t with text moves in Visu",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 10
        AccessibilityStrategyVisualMode.head = 35
        
        let returnedElement = applyMove(on: element, using: element.currentFileText.beginningOfWordBackward)
        
        XCTAssertEqual(returnedElement?.caretLocation, 10)
        XCTAssertEqual(returnedElement?.selectedLength, 21)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_anchor_is_after_the_head_it_moves_the_caret_to_the_new_head_location_related_to_the_word_motion_move_and_increases_the_selected_length() {
        let text = """
in Visual Mode Characterwise we
always move from the anchor, not
from the caret location
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 88,
            caretLocation: 57,
            selectedLength: 11,
            selectedText: """
or, not
fro
""",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 88,
                number: 2,
                start: 32,
                end: 65
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 67
        AccessibilityStrategyVisualMode.head = 57
        
        let returnedElement = applyMove(on: element, using: element.currentFileText.beginningOfWORDBackward)
        
        XCTAssertEqual(returnedElement?.caretLocation, 53)
        XCTAssertEqual(returnedElement?.selectedLength, 15)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_anchor_and_the_head_are_equal_it_does_not_get_blocked() {
        let text = "because currently it seems it does"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 34,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "i",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 34
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 18
        
        let returnedElement = applyMove(on: element, using: element.currentFileText.endOfWordBackward)
        
        XCTAssertEqual(returnedElement?.caretLocation, 16)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_it_works_and_goes_to_new_head_location_related_to_the_word_motion_move() {
        let text = """
caret is on its
own empty
line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 31,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 4,
                start: 31,
                end: 31
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 31
        AccessibilityStrategyVisualMode.head = 31
        
        let returnedElement = applyMove(on: element, using: element.currentFileText.beginningOfWordBackward)
        
        XCTAssertEqual(returnedElement?.caretLocation, 26)
        XCTAssertEqual(returnedElement?.selectedLength, 5)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}



// emojis
extension ASUT_VM_wordMotionBackward_Tests {
    
    func test_that_it_handles_emojis_when_head_and_anchor_are_the_same() {
        let text = "because currently-🤖️t seems it does"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 18,
            selectedLength: 3,
            selectedText: "🤖️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 1,
                start: 0,
                end: 36
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 18
        
        let returnedElement = applyMove(on: element, using: element.currentFileText.endOfWORDBackward)
        
        XCTAssertEqual(returnedElement?.caretLocation, 6)
        XCTAssertEqual(returnedElement?.selectedLength, 15)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_it_handles_emojis_when_the_head_is_before_the_anchor() {
        let text = "because ☀️urrently 🤖️t seems it does"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 37,
            caretLocation: 10,
            selectedLength: 12,
            selectedText: "urrently 🤖️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 19
        AccessibilityStrategyVisualMode.head = 10
        
        let returnedElement = applyMove(on: element, using: element.currentFileText.endOfWordBackward)
        
        XCTAssertEqual(returnedElement?.caretLocation, 8)
        XCTAssertEqual(returnedElement?.selectedLength, 14)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
