import XCTest
@testable import AccessibilityStrategy
import Common


class ASUT_VML_return_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(visualStyle: .linewise)
            
        return applyMoveBeingTested(on: element, &state)
                
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        vimEngineState.visualStyle = .linewise
        
        return asVisualMode.`return`(on: element, &vimEngineState)
    }

}


// TextFields
// kVE will handle the fact that return for TF never goes to AS, it goes to KS.
// coz AS return doesn't make sense in TF, and we will use KS to activate selections (dropdowns, lists etc.)


// Bip
extension ASUT_VML_return_Tests {
    
    func test_that_if_the_head_is_at_the_last_line_then_it_bips() {
        let text = """
well last line
or TV 🍍️
or a TF same same
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 15,
            selectedLength: 27,
            selectedText: """
or TV 🍍️
or a TF same same
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 2,
                start: 15,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 15
        AccessibilityStrategyVisualMode.head = 41
                
        var state = VimEngineState(lastMoveBipped: false)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertTrue(state.lastMoveBipped)
    }

}


// TextViews
extension ASUT_VML_return_Tests {
    
    func test_that_if_the_head_is_after_the_anchor_then_it_extends_the_selection_by_one_line_below_at_a_time() {
        let text = """
so pressing j in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 0,
            selectedLength: 17,
            selectedText: "so pressing j in\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 1,
                start: 0,
                end: 12
            )!
        )
                
        AccessibilityStrategyVisualMode.head = 0
        AccessibilityStrategyVisualMode.anchor = 16
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 41)
    }
    
    func test_that_if_the_head_is_before_the_anchor_then_it_reduces_the_selection_by_one_line_below_at_a_time() {
        let text = """
so pressing j in
Visual Mode is gonna be
cool because it will reduce
the selection when the
head if before the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 117,
            caretLocation: 17,
            selectedLength: 100,
            selectedText: """
Visual Mode is gonna be
cool because it will reduce
the selection when the
head if before the anchor
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 117,
                number: 3,
                start: 17,
                end: 29
            )!
        )
        
        AccessibilityStrategyVisualMode.head = 17
        AccessibilityStrategyVisualMode.anchor = 116
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 76)
    }
    
    func test_that_it_does_not_skip_empty_lines() {
        let text = """
wow that one is

ass off lol
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 0,
            selectedLength: 16,
            selectedText: "wow that one is\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 1,
                start: 0,
                end: 13
            )!
        )
        
        AccessibilityStrategyVisualMode.head = 0
        AccessibilityStrategyVisualMode.anchor = 15
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 17)
    }
    
}
