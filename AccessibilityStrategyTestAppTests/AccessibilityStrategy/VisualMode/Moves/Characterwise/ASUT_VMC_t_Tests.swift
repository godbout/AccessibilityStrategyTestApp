@testable import AccessibilityStrategy
import XCTest


// see F for blah blah
class ASUT_VMC_t_Tests: ASVM_BaseTests {
    
    private func applyMove(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.tForVisualStyleCharacterwise(to: character, on: element)
    }
    
}


// Both
extension ASUT_VMC_t_Tests {
    
    func test_that_if_the_new_head_location_is_after_the_Anchor_then_it_selects_from_Anchor_to_the_new_head_location() {
        let text = "check if the move can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 9,
            selectedLength: 4,
            selectedText: "the ",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 1,
                start: 0,
                end: 51
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 12
       
        let returnedElement = applyMove(to: "i", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 9)
        XCTAssertEqual(returnedElement?.selectedLength, 33)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_new_head_location_is_before_the_Anchor_then_it_selects_from_the_new_head_location_until_the_Anchor() {
        let text = """
check if the move can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!
also on multiple lines 🌬️ because the calculation
of newHeadLocation needs some... calculation.
"""

        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 148,
            caretLocation: 58,
            selectedLength: 36,
            selectedText: "n multiple lines 🌬️ because the cal",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 2,
                start: 52,
                end: 103
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 93
        AccessibilityStrategyVisualMode.head = 58
        
        let returnedElement = applyMove(to: "s", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 72)
        XCTAssertEqual(returnedElement?.selectedLength, 22)
        XCTAssertNil(returnedElement?.selectedText)
    }

    func test_that_if_the_character_is_not_found_then_the_selection_does_not_move() {
        let text = """
gonna look
for a character
that is not there
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 13,
            selectedLength: 3,
            selectedText: "r a",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 2,
                start: 11,
                end: 27
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 13
        AccessibilityStrategyVisualMode.head = 15
        
        let returnedElement = applyMove(to: "z", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 13)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_it_is_looking_for_the_character_after_the_head_rather_than_after_the_anchor() {
        let text = "found some bug here"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 19,
            caretLocation: 2,
            selectedLength: 7,
            selectedText: "und som",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 1,
                start: 0,
                end: 19
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 2
        AccessibilityStrategyVisualMode.head = 8
       
        let returnedElement = applyMove(to: "o", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 2)
        XCTAssertEqual(returnedElement?.selectedLength, 7)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
