import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_rightBrace_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.rightBrace(on: element, state)
    }
   
}


// Both
extension ASUT_VMC_rightBrace_Tests {

    func test_that_if_the_Head_is_after_the_Anchor_then_it_extends_the_selection_to_the_new_HeadLocation() {
        let text = """
ok so
those are
paragraphs


so we need
to test well
"""            
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 52,
            caretLocation: 8,
            selectedLength: 13,
            selectedText: """
        ose are
        parag
        """,
            fullyVisibleArea: 0..<52,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 2,
                start: 6,
                end: 16
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 8
        AccessibilityStrategyVisualMode.head = 20
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 27)
    }
    
    func test_that_if_the_Head_is_before_the_Anchor_then_it_reduces_the_selection_to_the_newHeadLocation() {
        let text = """
ok so
those are
paragraphs


so we need
to test well
"""            
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 52,
            caretLocation: 8,
            selectedLength: 26,
            selectedText: """
        ose are
        paragraphs


        so we
        """,
            fullyVisibleArea: 0..<52,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 2,
                start: 6,
                end: 16
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 33
        AccessibilityStrategyVisualMode.head = 8
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 27)
        XCTAssertEqual(returnedElement.selectedLength, 7)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 33)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 27)
    }
    
}
