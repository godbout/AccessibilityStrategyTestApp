import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_rightParenthesis_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.rightParenthesis(on: element, vimEngineState)
    }
   
}


// Both
extension ASUT_VMC_rightParenthesis_Tests {

    func test_that_if_the_Head_is_after_the_Anchor_then_it_extends_the_selection_to_the_new_HeadLocation() {
        let text = "that's pretty much several sentences. together. hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 52,
            caretLocation: 9,
            selectedLength: 12,
            selectedText: """
        etty much se
        """,
            fullyVisibleArea: 0..<52,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 1,
                start: 0,
                end: 52
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 20
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 38)
    }
    
    func test_that_if_the_Head_is_before_the_Anchor_then_it_reduces_the_selection_to_the_newHeadLocation() {
        let text = "that's pretty much several sentences. together. hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 52,
            caretLocation: 9,
            selectedLength: 12,
            selectedText: """
        etty much se
        """,
            fullyVisibleArea: 0..<52,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 1,
                start: 0,
                end: 52
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 20
        AccessibilityStrategyVisualMode.head = 9
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 19)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 38)
    }
    
}


// bugs found
extension ASUT_VMC_rightParenthesis_Tests {
    
    func test_that_the_newHeadLocation_is_calculated_according_to_the_Head_and_not_the_caretLocation_or_selectionUpperBound() {
        let text = "that's pretty much several sentences. together. hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 52,
            caretLocation: 12,
            selectedLength: 33,
            selectedText: """
        y much several sentences. togethe
        """,
            fullyVisibleArea: 0..<52,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 1,
                start: 0,
                end: 52
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 44
        AccessibilityStrategyVisualMode.head = 12
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 38)
        XCTAssertEqual(returnedElement.selectedLength, 7)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 44)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 38)
    }
    
}
