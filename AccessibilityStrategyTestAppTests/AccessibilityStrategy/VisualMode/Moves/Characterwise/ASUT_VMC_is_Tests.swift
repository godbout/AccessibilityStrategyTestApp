import AccessibilityStrategy
import XCTest
import Common


class ASUT_VMC_is_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.is(on: element, vimEngineState)
    }
    
}


// TextFields and TextViews
extension ASUT_VMC_is_Tests {
    
    func test_that_if_the_Head_is_after_the_Anchor_it_extends_the_selection_to_the_end_of_the_inner_sentence_where_the_head_is() {
        let text = "brother. we're gonna need some sentences here. else it's not gonna work!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 72,
            caretLocation: 16,
            selectedLength: 8,
            selectedText: """
        onna nee
        """,
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 1,
                start: 0,
                end: 72
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 16
        AccessibilityStrategyVisualMode.head = 23
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_Head_is_before_the_Anchor_it_extends_the_selection_to_the_beginning_of_the_inner_sentence_where_the_Head_is() {
        let text = "brother. we're gonna need some sentences here. else it's not gonna work!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 72,
            caretLocation: 16,
            selectedLength: 8,
            selectedText: """
        onna nee
        """,
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 1,
                start: 0,
                end: 72
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 23
        AccessibilityStrategyVisualMode.head = 16
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 15)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_Head_and_the_Anchor_are_equal_it_selects_the_whole_inner_sentence_and_the_Anchor_gets_updated_to_the_beginning_of_the_inner_sentence_and_the_Head_gets_updated_to_the_end_of_the_inner_sentence() {
        let text = "brother. we're gonna need some sentences here. else it's not gonna work!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 72,
            caretLocation: 16,
            selectedLength: 1,
            selectedText: """
        o
        """,
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 1,
                start: 0,
                end: 72
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 16
        AccessibilityStrategyVisualMode.head = 16
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 37)
        XCTAssertNil(returnedElement.selectedText)
                
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 45)
    }
    
    func test_that_it_does_not_get_blocked_when_the_Head_is_after_the_Anchor_and_the_caret_is_at_the_end_of_an_inner_sentence() {
        let text = "brother. we're gonna need some sentences here. else it's not gonna work!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 72,
            caretLocation: 2,
            selectedLength: 6,
            selectedText: """
        other.
        """,
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 1,
                start: 0,
                end: 72
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 2
        AccessibilityStrategyVisualMode.head = 7
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 2)
        XCTAssertEqual(returnedElement.selectedLength, 7)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_does_not_get_blocked_when_the_Head_is_before_the_Anchor_and_the_caret_is_at_the_beginning_of_an_inner_sentence() {
        let text = "brother. we're gonna need some sentences here. else it's not gonna work!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 72,
            caretLocation: 47,
            selectedLength: 12,
            selectedText: """
        else it's no
        """,
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 1,
                start: 0,
                end: 72
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 58
        AccessibilityStrategyVisualMode.head = 47
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 46)
        XCTAssertEqual(returnedElement.selectedLength, 13)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    // TODO: FR
    func test_that_it_does_not_get_blocked_when_the_Head_if_after_the_Anchor_and_the_caret_is_at_the_end_of_an_inner_sentence_right_before_an_EmptyLine() {
        let text = """
ok so this is. something
else

altogether. right?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 50,
            caretLocation: 17,
            selectedLength: 12,
            selectedText: """
        mething
        else
        """,
            fullyVisibleArea: 0..<50,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 17
        AccessibilityStrategyVisualMode.head = 28
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 25)
        XCTAssertNil(returnedElement.selectedText)
    }

}
