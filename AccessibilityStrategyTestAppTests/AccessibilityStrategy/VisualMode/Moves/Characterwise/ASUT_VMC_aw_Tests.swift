import AccessibilityStrategy
import XCTest
import Common


class ASUT_VMC_aw_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.aw(on: element, vimEngineState)
    }
    
}


// TextFields and TextViews
extension ASUT_VMC_aw_Tests {
    
    func test_that_if_the_Head_is_after_the_Anchor_it_extends_the_selection_to_the_end_of_the_aWord_where_the_Head_is() {
        let text = "the Head and the Anchor position are important to know in which way we extend the selection"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 91,
            caretLocation: 20,
            selectedLength: 20,
            selectedText: "hor position are imp",
            fullyVisibleArea: 0..<91,
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
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    // TODO: FR failing. coz we as is very different? or there's a way in VMC?
    func test_that_if_the_Head_is_before_the_Anchor_it_extends_the_selection_to_the_beginning_of_the_aWord_where_the_Head_is() {
        let text = "the Head and the Anchor ⚓️⚓️⚓️⚓️ position are important to know in which way we extend the selection"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 100,
            caretLocation: 28,
            selectedLength: 21,
            selectedText: "⚓️⚓️ position are imp",
            fullyVisibleArea: 0..<100,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 100,
                number: 1,
                start: 0,
                end: 100
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 48
        AccessibilityStrategyVisualMode.head = 28
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 23)
        XCTAssertEqual(returnedElement.selectedLength, 26)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_Head_and_the_Anchor_are_equal_it_selects_the_whole_aWord_and_the_Anchor_gets_updated_to_the_beginning_of_the_aWord_and_the_Head_gets_updated_to_the_end_of_the_aWord() {
        let text = "when anchor and head are equal the whole word is selected and the anchor and head are actually deliberately changed"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 115,
            caretLocation: 100,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<115,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 1,
                start: 0,
                end: 115
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 100
        AccessibilityStrategyVisualMode.head = 100
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 95)
        XCTAssertEqual(returnedElement.selectedLength, 13)
        XCTAssertNil(returnedElement.selectedText)
                
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 95)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 107)
    }
    
    func test_that_it_does_not_get_blocked_when_the_Head_if_after_the_Anchor_and_the_caret_is_at_the_end_of_an_aWord() {
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
            selectedLength: 7,
            selectedText: """
        ferent 
        """,
            fullyVisibleArea: 0..<147,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 147,
                number: 2,
                start: 43,
                end: 78
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 61
        AccessibilityStrategyVisualMode.head = 67
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 61)
        XCTAssertEqual(returnedElement.selectedLength, 16)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    // TODO: FR failing. coz we as is very different? or there's a way in VMC?
    func test_that_it_does_not_get_blocked_when_the_Head_if_before_the_Anchor_and_the_caret_is_at_the_beginning_of_an_aWord() {
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
            caretLocation: 57,
            selectedLength: 6,
            selectedText: """
         diffe
        """,
            fullyVisibleArea: 0..<147,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 147,
                number: 2,
                start: 43,
                end: 78
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 62
        AccessibilityStrategyVisualMode.head = 57
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 54)
        XCTAssertEqual(returnedElement.selectedLength, 9)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
