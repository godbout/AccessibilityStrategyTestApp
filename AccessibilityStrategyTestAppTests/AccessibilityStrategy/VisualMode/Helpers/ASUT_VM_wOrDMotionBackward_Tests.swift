@testable import AccessibilityStrategy
import XCTest


// see wordMotionForward for blah blah
// wordMotionBackward called by b, B, ge, gE.
class ASUT_VM_wordMotionBackward_Tests: ASUT_VM_BaseTests {

    private func applyMove(times count: Int = 1, on element: AccessibilityTextElement, using wordMotionBackwardFunction: (Int) -> Int?) -> AccessibilityTextElement {
        return asVisualMode.wOrDMotionBackward(times: count, on: element, using: wordMotionBackwardFunction)
    }
    
}


// count
extension ASUT_VM_wordMotionBackward_Tests {
    
    func test_that_it_implements_the_count_system_for_when_the_Head_is_after_or_equal_to_the_Anchor() {
        let text = "gonna start with text moves in Visual Mode"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 10,
            selectedLength: 25,
            selectedText: "t with text moves in Visu",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 10
        AccessibilityStrategyVisualMode.head = 34
        
        let returnedElement = applyMove(times: 6, on: element, using: element.fileText.beginningOfWordBackward)
        
        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 5)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_implements_the_count_system_for_when_the_Head_is_before_the_Anchor() {
        let text = "gonna start with text moves in Visual Mode"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 22,
            selectedLength: 14,
            selectedText: "moves in Visua",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 35
        AccessibilityStrategyVisualMode.head = 22
        
        let returnedElement = applyMove(times: 3, on: element, using: element.fileText.endOfWordBackward)
        
        XCTAssertEqual(returnedElement.caretLocation, 10)
        XCTAssertEqual(returnedElement.selectedLength, 26)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_it_selects_until_the_beginning_of_the_text() {
        let text = """
long ass text there
and if the count is too high
then something magical
will happen
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 83,
            caretLocation: 53,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<83,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 83,
                number: 3,
                start: 49,
                end: 72
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 53
        AccessibilityStrategyVisualMode.head = 53
        
        let returnedElement = applyMove(times: 69, on: element, using: element.fileText.endOfWordBackward)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 54)
        XCTAssertNil(returnedElement.selectedText)
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
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 10
        AccessibilityStrategyVisualMode.head = 34
        
        let returnedElement = applyMove(on: element, using: element.fileText.beginningOfWordBackward)
        
        XCTAssertEqual(returnedElement.caretLocation, 10)
        XCTAssertEqual(returnedElement.selectedLength, 22)
        XCTAssertNil(returnedElement.selectedText)
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
            fullyVisibleArea: 0..<88,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 88,
                number: 2,
                start: 32,
                end: 65
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 67
        AccessibilityStrategyVisualMode.head = 57
        
        let returnedElement = applyMove(on: element, using: element.fileText.beginningOfWORDBackward)
        
        XCTAssertEqual(returnedElement.caretLocation, 53)
        XCTAssertEqual(returnedElement.selectedLength, 15)
        XCTAssertNil(returnedElement.selectedText)
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
            fullyVisibleArea: 0..<34,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 18
        
        let returnedElement = applyMove(on: element, using: element.fileText.endOfWordBackward)
        
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
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
            fullyVisibleArea: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 4,
                start: 31,
                end: 31
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 31
        AccessibilityStrategyVisualMode.head = 31
        
        let returnedElement = applyMove(on: element, using: element.fileText.beginningOfWordBackward)
        
        XCTAssertEqual(returnedElement.caretLocation, 26)
        XCTAssertEqual(returnedElement.selectedLength, 5)
        XCTAssertNil(returnedElement.selectedText)
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
            fullyVisibleArea: 0..<36,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 1,
                start: 0,
                end: 36
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 18
        
        let returnedElement = applyMove(on: element, using: element.fileText.endOfWORDBackward)
        
        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 15)
        XCTAssertNil(returnedElement.selectedText)
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
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 19
        AccessibilityStrategyVisualMode.head = 10
        
        let returnedElement = applyMove(on: element, using: element.fileText.endOfWordBackward)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 14)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
