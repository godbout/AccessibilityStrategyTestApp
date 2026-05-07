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
    
    // TODO: FR do this plus when there's a newline
//    func test_that_it_does_not_get_blocked_when_the_Head_if_after_the_Anchor_and_the_caret_is_at_the_end_of_an_inner_word() {
//        let text = """
//so it seems that calculating the innerWord
//is going to be different depending
//on where the anchor and head are positioned
//in relation to each other
//"""
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 147,
//            caretLocation: 61,
//            selectedLength: 6,
//            selectedText: "ferent",
//            fullyVisibleArea: 0..<147,
//            currentScreenLine: ScreenLine(
//                fullTextValue: text,
//                fullTextLength: 147,
//                number: 2,
//                start: 43,
//                end: 78
//            )!
//        )
//        
//        AccessibilityStrategyVisualMode.anchor = 61
//        AccessibilityStrategyVisualMode.head = 66
//       
//        let returnedElement = applyMoveBeingTested(on: element)
//        
//        XCTAssertEqual(returnedElement.caretLocation, 61)
//        XCTAssertEqual(returnedElement.selectedLength, 7)
//        XCTAssertNil(returnedElement.selectedText)
//    }
//    
//    func test_that_it_does_not_get_blocked_when_the_Head_if_before_the_Anchor_and_the_caret_is_at_the_beginning_of_an_inner_word() {
//        let text = """
//so it seems that calculating the innerWord
//is going to be different depending
//on where the anchor and head are positioned
//in relation to each other
//"""
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 147,
//            caretLocation: 58,
//            selectedLength: 5,
//            selectedText: "diffe",
//            fullyVisibleArea: 0..<147,
//            currentScreenLine: ScreenLine(
//                fullTextValue: text,
//                fullTextLength: 147,
//                number: 2,
//                start: 43,
//                end: 78
//            )!
//        )
//        
//        AccessibilityStrategyVisualMode.anchor = 62
//        AccessibilityStrategyVisualMode.head = 58
//       
//        let returnedElement = applyMoveBeingTested(on: element)
//        
//        XCTAssertEqual(returnedElement.caretLocation, 57)
//        XCTAssertEqual(returnedElement.selectedLength, 6)
//        XCTAssertNil(returnedElement.selectedText)
//    }

}
