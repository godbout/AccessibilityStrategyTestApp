import AccessibilityStrategy
import XCTest
import Common


// see F for blah blah
class ASUT_VMC_f_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .characterwise)
                
        return asVisualMode.f(times: count, to: character, on: element, state)
    }
    
}


// count
extension ASUT_VMC_f_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "check if f can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 44,
            caretLocation: 9,
            selectedLength: 4,
            selectedText: "f ca",
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 44
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 12
       
        let returnedElement = applyMoveBeingTested(times: 2, to: "i", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 33)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_and_therefore_character_is_not_found_then_it_does_not_move() {
        let text = "check if f can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 44,
            caretLocation: 9,
            selectedLength: 4,
            selectedText: "f ca",
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 44
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 12
       
        let returnedElement = applyMoveBeingTested(times: 4, to: "i", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 4)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// Both
extension ASUT_VMC_f_Tests {
    
    func test_that_if_the_newHeadLocation_is_after_the_Anchor_then_it_selects_from_Anchor_to_the_newHeadLocation() {
        let text = "check if f can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 44,
            caretLocation: 9,
            selectedLength: 4,
            selectedText: "f ca",
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 44
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 12
       
        let returnedElement = applyMoveBeingTested(to: "i", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextViews
extension ASUT_VMC_f_Tests {
    
    func test_that_if_the_newHeadLocation_is_before_the_Anchor_then_it_selects_from_the_newHeadLocation_until_the_Anchor() {
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
            fullyVisibleArea: 0..<141,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 141,
                number: 2,
                start: 45,
                end: 96
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 74
        AccessibilityStrategyVisualMode.head = 60

        let returnedElement = applyMoveBeingTested(to: "s", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 66)
        XCTAssertEqual(returnedElement.selectedLength, 9)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_searches_from_the_lineAtHead_and_not_from_the_currentFileLine_that_is_the_line_from_the_caretLocation() {
        let text = """
check if f can 🍃️🍃️🍃️🍃️🍃️🍃️ find shit!
also on multiple lines 🌬️ because the calculation
of newHeadLocation needs some... calculation.
"""

        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 141,
            caretLocation: 53,
            selectedLength: 53,
            selectedText: """
        multiple lines 🌬️ because the calculation
        of newHead
        """,
            fullyVisibleArea: 0..<53,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 141,
                number: 2,
                start: 45,
                end: 96
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 53
        AccessibilityStrategyVisualMode.head = 105

        let returnedElement = applyMoveBeingTested(to: "s", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 53)
        XCTAssertEqual(returnedElement.selectedLength, 67)
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
            fullyVisibleArea: 0..<44,
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
    
    func test_that_it_is_looking_for_the_character_after_the_Head_rather_than_after_the_Anchor() {
        let text = "found some bug here"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 19,
            caretLocation: 2,
            selectedLength: 7,
            selectedText: "und som",
            fullyVisibleArea: 0..<19,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 19,
                number: 1,
                start: 0,
                end: 19
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 2
        AccessibilityStrategyVisualMode.head = 8
       
        let returnedElement = applyMoveBeingTested(to: "o", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 2)
        XCTAssertEqual(returnedElement.selectedLength, 7)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
