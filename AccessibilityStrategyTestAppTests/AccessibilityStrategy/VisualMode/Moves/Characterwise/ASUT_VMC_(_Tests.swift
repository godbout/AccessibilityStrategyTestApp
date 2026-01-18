import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_leftParenthesis_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.leftParenthesis(on: element, vimEngineState)
    }
   
}


// TextFields and TextViews
extension ASUT_VMC_leftParenthesis_Tests {

    func test_that_if_the_Head_is_before_the_Anchor_then_it_extends_the_selection_to_the_new_HeadLocation() {
        let text = "that's pretty much several sentences. together. hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 52,
            caretLocation: 41,
            selectedLength: 8,
            selectedText: """
        ether. h
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
        
        AccessibilityStrategyVisualMode.anchor = 48
        AccessibilityStrategyVisualMode.head = 41
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 38)
        XCTAssertEqual(returnedElement.selectedLength, 11)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 48)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 38)
    }
    
    func test_that_if_the_Head_is_after_the_Anchor_then_it_reduces_the_selection_to_the_newHeadLocation() {
        let text = "that's pretty much several sentences. together. hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 52,
            caretLocation: 28,
            selectedLength: 22,
            selectedText: """
        entences. together. he
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
        
        AccessibilityStrategyVisualMode.anchor = 28
        AccessibilityStrategyVisualMode.head = 49
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 28)
        XCTAssertEqual(returnedElement.selectedLength, 21)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 28)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 48)
    }
    
}
