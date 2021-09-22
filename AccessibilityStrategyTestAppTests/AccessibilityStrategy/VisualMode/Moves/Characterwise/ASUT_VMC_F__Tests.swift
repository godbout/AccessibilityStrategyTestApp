@testable import AccessibilityStrategy
import XCTest


// using TextEngine moves, that are already tested.
// here we just have to text that the caretLocation and selectedLength
// are correct when character is found and not found.
class ASUT_VMC_F__Tests: ASVM_BaseTests {
    
    private func applyMove(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.FForVisualStyleCharacterwise(to: character, on: element)
    }
    
}


// Both
extension ASUT_VMC_F__Tests {
    
    func test_that_if_the_new_head_location_is_after_the_Anchor_then_it_selects_from_Anchor_to_the_new_head_location() {
        let text = "check if F can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 7,
            selectedLength: 35,
            selectedText: "f F can 🍃️🍃️🍃️🍃️🍃️🍃️ find shi",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 1,
                start: 0,
                end: 44
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 7
        AccessibilityStrategyVisualMode.head = 42
       
        let returnedElement = applyMove(to: "c", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 7)
        XCTAssertEqual(returnedElement?.selectedLength, 5)
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
        
        XCTAssertEqual(returnedElement?.caretLocation, 54)
        XCTAssertEqual(returnedElement?.selectedLength, 40)
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
    
    func test_that_it_is_looking_for_the_character_before_the_head_rather_than_before_the_anchor() {
        let text = "found some bug here"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 19,
            caretLocation: 4,
            selectedLength: 12,
            selectedText: "d some bug h",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 1,
                start: 0,
                end: 19
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 15
        AccessibilityStrategyVisualMode.head = 4
       
        let returnedElement = applyMove(to: "b", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 4)
        XCTAssertEqual(returnedElement?.selectedLength, 12)
        XCTAssertNil(returnedElement?.selectedText)
    }

}
