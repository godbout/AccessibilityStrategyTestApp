@testable import AccessibilityStrategy
import XCTest


class ASUT_VMC_iW__Tests: ASVM_BaseTests {

    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.iWForVisualStyleCharacterwise(on: element)
    }
    
}


// Both
extension ASUT_VMC_iW__Tests {
    
    func test_that_if_the_Head_is_after_the_Anchor_it_extends_the_selection_to_the_end_of_the_word_where_the_head_is() {
        let text = "the Head and the Anchor position are important-to know in which way we extend the selection"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 91,
            caretLocation: 20,
            selectedLength: 20,
            selectedText: "hor position are imp",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 91,
                number: 1,
                start: 0,
                end: 55
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 20
        AccessibilityStrategyVisualMode.head = 39
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 20)
        XCTAssertEqual(returnedElement?.selectedLength, 29)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_Head_is_before_the_Anchor_it_extends_the_selection_to_the_beginning_of_the_word_where_the_Head_is() {
        let text = "the Head and the Anchor⚓️⚓️⚓️⚓️ position are important to know in which way we extend the selection"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 99,
            caretLocation: 27,
            selectedLength: 21,
            selectedText: "⚓️⚓️ position are imp",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 99,
                number: 1,
                start: 0,
                end: 58
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 47
        AccessibilityStrategyVisualMode.head = 27
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 17)
        XCTAssertEqual(returnedElement?.selectedLength, 31)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_Head_and_the_Anchor_are_equal_it_selects_the_whole_inner_word_and_the_Anchor_gets_updated_to_the_beginning_of_the_word_and_the_Head_gets_updated_to_the_end_of_the_word() {
        let text = "when anchor and head are equal the whole word is selected and the anchor and head are actually-deliberately-ch anged"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 100,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 2,
                start: 58,
                end: 116
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 100
        AccessibilityStrategyVisualMode.head = 100
       
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 86)
        XCTAssertEqual(returnedElement?.selectedLength, 24)
        XCTAssertNil(returnedElement?.selectedText)
                
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 86)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 109)
    }
    
    func test_that_it_does_not_get_blocked_when_the_Head_if_after_the_Anchor_and_the_caret_is_at_the_end_of_a_word() {
        let text = """
so it seems that calculating the innerWord
is going to be different depending
on where the anchor and head are positioned
in relation to each other
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 147,
            caretLocation: 61,
            selectedLength: 6,
            selectedText: "ferent",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 147,
                number: 2,
                start: 43,
                end: 78
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 61
        AccessibilityStrategyVisualMode.head = 66
       
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 61)
        XCTAssertEqual(returnedElement?.selectedLength, 7)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_it_does_not_get_blocked_when_the_Head_if_before_the_Anchor_and_the_caret_is_at_the_beginning_of_a_word() {
        let text = """
so it seems that calculating the innerWord
is going to be different depending
on where the anchor and head are positioned
in relation to each other
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 147,
            caretLocation: 58,
            selectedLength: 5,
            selectedText: "diffe",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 147,
                number: 2,
                start: 43,
                end: 78
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 62
        AccessibilityStrategyVisualMode.head = 58
       
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 57)
        XCTAssertEqual(returnedElement?.selectedLength, 6)
        XCTAssertNil(returnedElement?.selectedText)
    }

}
