import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_leftBrace_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.leftBrace(on: element, vimEngineState)
    }
   
}


// TextFields and TextViews
extension ASUT_VMC_leftBrace_Tests {

    func test_that_if_the_Head_is_before_the_Anchor_then_it_extends_the_selection_to_the_new_HeadLocation() {
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
            caretLocation: 33,
            selectedLength: 16,
            selectedText: """
        e need
        to test w
        """,
            fullyVisibleArea: 0..<52,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 6,
                start: 29,
                end: 40
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 48
        AccessibilityStrategyVisualMode.head = 33
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 28)
        XCTAssertEqual(returnedElement.selectedLength, 21)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 48)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 28)
    }
    
    func test_that_if_the_Head_is_after_the_Anchor_then_it_reduces_the_selection_to_the_newHeadLocation() {
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
            caretLocation: 31,
            selectedLength: 14,
            selectedText: """
         we need
        to te
        """,
            fullyVisibleArea: 0..<52,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 6,
                start: 29,
                end: 40
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 31
        AccessibilityStrategyVisualMode.head = 44
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 28)
        XCTAssertEqual(returnedElement.selectedLength, 4)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 31)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 28)
    }
    
}
