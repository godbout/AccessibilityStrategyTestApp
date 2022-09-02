import AccessibilityStrategy
import XCTest
import Common


// VMC ip is massively weird in Vim:
// 1. if the selection is on the same line, then it changes to Linewise
// and selects the whole paragraph at first ip.
// 2. if the selection is on several lines, it stays Characterwise
// but it doesn't even do paragraphs if going down LOL. it stops before. i don't even understand the logic.
// CONCLUSION: for kV currently i'm always switching to Linewise
// the test to enter VM in Linewise is done in KVE, not here.
class ASUT_VMC_ip_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.ip(on: element, state)
    }
    
}


extension ASUT_VMC_ip_Tests {

    func test_that_when_starting_in_VMC_and_the_Head_is_after_the_Anchor_then_the_move_selects_the_whole_innerParagraph_counting_from_the_Head_and_recalculated_the_Anchor_and_Head_properly() {
        let text = """
so we are in VMC
and some stuff

is selected over maybe
those two lines
and when we do ip

it's gonna select the whole
innerParagraph
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 133,
            caretLocation: 58,
            selectedLength: 19,
            selectedText: """
        ose two lines
        and w
        """,
            fullyVisibleArea: 0..<133,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 133,
                number: 5,
                start: 56,
                end: 72
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 58
        AccessibilityStrategyVisualMode.head = 76
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 33)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 89)
        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 57)
    }
    
    func test_that_when_starting_in_VMC_and_the_Head_is_before_the_Anchor_then_the_move_selects_the_whole_innerParagraph_counting_from_the_Head_and_recalculated_the_Anchor_and_Head_properly() {
        let text = """
so we are in VMC
and some stuff

is selected over maybe
those two lines
and when we do ip

it's gonna select the whole
innerParagraph
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 133,
            caretLocation: 58,
            selectedLength: 19,
            selectedText: """
        ose two lines
        and w
        """,
            fullyVisibleArea: 0..<133,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 133,
                number: 5,
                start: 56,
                end: 72
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 76
        AccessibilityStrategyVisualMode.head = 58
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 89)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 33)
        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 57)
    }
    
    func test_that_when_starting_in_VMC_and_the_Head_and_the_Anchor_are_equal_then_the_move_selects_the_whole_innerParagraph_counting_from_the_Head_and_recalculated_the_Anchor_and_Head_properly() {
        let text = """
so we are in VMC
and some stuff

is selected over maybe
those two lines
and when we do ip

it's gonna select the whole
innerParagraph
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 133,
            caretLocation: 100,
            selectedLength: 1,
            selectedText: """
        a
        """,
            fullyVisibleArea: 0..<133,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 133,
                number: 8,
                start: 91,
                end: 119
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 100
        AccessibilityStrategyVisualMode.head = 100
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 91)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 132)
        XCTAssertEqual(returnedElement.caretLocation, 91)
        XCTAssertEqual(returnedElement.selectedLength, 42)
    }

    
}
