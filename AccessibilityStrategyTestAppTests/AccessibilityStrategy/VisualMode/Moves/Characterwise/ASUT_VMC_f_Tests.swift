@testable import AccessibilityStrategy
import XCTest


// see F for blah blah
class ASUT_VMC_f_Tests: ASVM_BaseTests {
    
    private func applyMove(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.fForVisualStyleCharacterwise(to: character, on: element)
    }
    
}


// Both
extension ASUT_VMC_f_Tests {
    
    func test_that_if_the_new_head_location_is_after_the_Anchor_then_it_selects_from_Anchor_to_the_new_head_location() {
        let text = "check if f can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 44,
            caretLocation: 9,
            selectedLength: 4,
            selectedText: "f ca",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 1,
                start: 0,
                end: 44
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 12
       
        let returnedElement = applyMove(to: "i", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 9)
        XCTAssertEqual(returnedElement?.selectedLength, 27)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_new_head_location_is_before_the_Anchor_then_it_selects_from_the_new_head_location_until_the_Anchor() {
        let text = """
check if f can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!
also on multiple lines 🌬️ because the calculation
of newHeadLocation needs some... calculation.
"""

        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 141,
            caretLocation: 60,
            selectedLength: 15,
            selectedText: "e lines 🌬️ bec",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 2,
                start: 45,
                end: 96
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 74
        AccessibilityStrategyVisualMode.head = 60

        let returnedElement = applyMove(to: "s", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 66)
        XCTAssertEqual(returnedElement?.selectedLength, 9)
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
                fullText: text,
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
                fullText: text,
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
