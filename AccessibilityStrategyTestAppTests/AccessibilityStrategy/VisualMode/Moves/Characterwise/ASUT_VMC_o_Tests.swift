@testable import AccessibilityStrategy
import XCTest


class ASUT_VMC_o_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.o(on: element) 
    }
    
}


// TextFields and TextViews
extension ASUT_VMC_o_Tests {
    
    func test_that_if_the_anchor_is_the_caret_location_and_the_head_is_the_end_of_the_selection_then_it_switches_them() {
        let text = "a sentence with a word, or more..."
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 34,
            caretLocation: 10,
            selectedLength: 4,
            selectedText: """
         wit
        """,
            fullyVisibleArea: 0..<34,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 10
        AccessibilityStrategyVisualMode.head = 14
        
        _ = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 14)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 10)        
    }
    
    func test_that_if_the_anchor_is_the_end_of_the_selection_and_the_head_is_the_caret_location_then_it_switches_them() {
        let text = """
now we gonna use
some like a little
longer text hehe
tricky
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 59,
            caretLocation: 19,
            selectedLength: 22,
            selectedText: """
        me like a little
        longe
        """,
            fullyVisibleArea: 0..<59,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 59,
                number: 2,
                start: 17,
                end: 36
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 40
        AccessibilityStrategyVisualMode.head = 19
        
        _ = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 19)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 40)  
    }
    
    func test_that_it_does_not_move_the_VM_head_and_anchor_if_they_are_both_the_same() {
        let text = """
another one
my friend
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 21,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "f",
            fullyVisibleArea: 0..<21,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 21,
                number: 2,
                start: 12,
                end: 21
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 15
        AccessibilityStrategyVisualMode.head = 15
        
        _ = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 15)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 15)  
    }
    
}

// emojis
// nothing to do here
extension ASUT_VMC_o_Tests {}
