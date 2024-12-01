import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML_ip_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .linewise)
        
        return asVisualMode.ip(on: element, vimEngineState)
    }
   
}


extension ASUT_VML_ip_Tests {

    func test_that_if_the_Anchor_and_the_Head_are_on_the_same_line_and_the_Head_is_after_the_Anchor_then_it_selects_the_whole_current_innerParagraph_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
ok so time to
play with the


fucking VML ip
heheh
he
hoho


hmm are you
dumb?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 45,
            selectedLength: 6,
            selectedText: """
        heheh

        """,
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 6,
                start: 45,
                end: 51
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 45
        AccessibilityStrategyVisualMode.head = 50
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 30)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 58)
        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 29)
    }
    
    func test_that_if_the_Anchor_and_the_Head_are_on_the_same_line_and_the_Head_is_before_the_Anchor_then_it_selects_the_whole_current_innerParagraph_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
ok so time to
play with the


fucking VML ip
heheh
he
hoho


hmm are you
dumb?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 45,
            selectedLength: 6,
            selectedText: """
        heheh

        """,
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 6,
                start: 45,
                end: 51
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 50
        AccessibilityStrategyVisualMode.head = 45
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 30)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 58)
        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 29)
    }
    
    func test_that_if_the_Anchor_and_the_Head_are_not_on_the_same_line_and_the_Head_is_after_the_Anchor_then_it_extends_the_selection_to_the_next_innerParagraph_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
ok so time to
play with the


fucking VML ip
heheh
he
hoho


hmm are you
dumb?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 45,
            selectedLength: 9,
            selectedText: """
        heheh
        he

        """,
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 6,
                start: 45,
                end: 51
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 45
        AccessibilityStrategyVisualMode.head = 53
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 45)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 58)
        XCTAssertEqual(returnedElement.caretLocation, 45)
        XCTAssertEqual(returnedElement.selectedLength, 14)
    }
    
    func test_that_if_the_Anchor_and_the_Head_are_not_on_the_same_line_and_the_Head_is_before_the_Anchor_then_it_extends_the_selection_to_the_previous_innerParagraph_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
ok so time to
play with the


fucking VML ip
heheh
he
hoho


hmm are you
dumb?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 45,
            selectedLength: 9,
            selectedText: """
        heheh
        he

        """,
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 6,
                start: 45,
                end: 51
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 53
        AccessibilityStrategyVisualMode.head = 45
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 53)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 30)
        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 24)
    }
    
}
