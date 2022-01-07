import XCTest
import AccessibilityStrategy
import VimEngineState


// see F for blah blah
class ASUT_VMC_T__Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualModeStyle: .characterwise)
                
        return asVisualMode.T(times: count, to: character, on: element, state)
    }
    
}


// count
extension ASUT_VMC_T__Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "check if the move can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 7,
            selectedLength: 35,
            selectedText: "f the move can 🍃️🍃️🍃️🍃️🍃️🍃️ f",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 7
        AccessibilityStrategyVisualMode.head = 42
       
        let returnedElement = applyMoveBeingTested(times: 2, to: "c", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 4)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_and_therefore_character_is_not_found_then_it_does_not_move() {
        let text = "check if the move can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 7,
            selectedLength: 35,
            selectedText: "f the move can 🍃️🍃️🍃️🍃️🍃️🍃️ f",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 7
        AccessibilityStrategyVisualMode.head = 42
       
        let returnedElement = applyMoveBeingTested(times: 69, to: "c", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 7)
        XCTAssertEqual(returnedElement.selectedLength, 35)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// Both
extension ASUT_VMC_T__Tests {
    
    func test_that_if_the_new_head_location_is_after_the_Anchor_then_it_selects_from_Anchor_to_the_new_head_location() {
        let text = "check if the move can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 7,
            selectedLength: 35,
            selectedText: "f the move can 🍃️🍃️🍃️🍃️🍃️🍃️ f",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 7
        AccessibilityStrategyVisualMode.head = 42
       
        let returnedElement = applyMoveBeingTested(to: "c", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 7)
        XCTAssertEqual(returnedElement.selectedLength, 13)
        XCTAssertNil(returnedElement.selectedText)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 148,
                number: 2,
                start: 52,
                end: 103
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 93
        AccessibilityStrategyVisualMode.head = 58
        
        let returnedElement = applyMoveBeingTested(to: "s", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 55)
        XCTAssertEqual(returnedElement.selectedLength, 39)
        XCTAssertNil(returnedElement.selectedText)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 2,
                start: 11,
                end: 27
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 13
        AccessibilityStrategyVisualMode.head = 15
        
        let returnedElement = applyMoveBeingTested(to: "z", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 13)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 19,
                number: 1,
                start: 0,
                end: 19
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 15
        AccessibilityStrategyVisualMode.head = 4
       
        let returnedElement = applyMoveBeingTested(to: "b", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertNil(returnedElement.selectedText)
    }

}
