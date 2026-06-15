import AccessibilityStrategy
import XCTest
import Common


class ASUT_VMC_iW__Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.iW(on: element, vimEngineState)
    }
    
}


// TextFields and TextViews
extension ASUT_VMC_iW__Tests {
    
    func test_that_if_the_Head_is_after_the_Anchor_it_extends_the_selection_to_the_end_of_the_innerWORD_where_the_Head_is() {
        let text = "the Head and the Anchor position are important-to know in which way we extend the selection"
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
        XCTAssertEqual(returnedElement.selectedLength, 29)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_Head_is_before_the_Anchor_it_extends_the_selection_to_the_beginning_of_the_innerWORD_where_the_Head_is() {
        let text = "the Head and the Anchor⚓️⚓️⚓️⚓️ position are important to know in which way we extend the selection"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 99,
            caretLocation: 27,
            selectedLength: 21,
            selectedText: "⚓️⚓️ position are imp",
            fullyVisibleArea: 0..<99,
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
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 31)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_Head_and_the_Anchor_are_equal_it_selects_the_whole_innerWORD_and_the_Anchor_gets_updated_to_the_beginning_of_the_innerWORD_and_the_Head_gets_updated_to_the_end_of_the_innerWORD() {
        let text = "when anchor and head are equal the whole word is selected and the anchor and head are actually-deliberately-ch anged"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 100,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<116,
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
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 86)
        XCTAssertEqual(returnedElement.selectedLength, 24)
        XCTAssertNil(returnedElement.selectedText)
                
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 86)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 109)
    }
    
    func test_that_if_the_Head_and_the_Anchor_are_equal_and_the_caret_is_at_the_last_word_of_a_line_that_is_not_the_last_line_then_it_selects_the_whole_innerWord_and_the_Anchor_gets_updated_to_the_beginning_of_the_innerWord_and_the_Head_gets_updated_to_the_end_of_the_innerWord() {
        let text = """
so it's gonna select the whole wo-Rd
at the end of previous line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 64,
            caretLocation: 32,
            selectedLength: 1,
            selectedText: """
        o
        """,
            fullyVisibleArea: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 32
        AccessibilityStrategyVisualMode.head = 32
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 31)
        XCTAssertEqual(returnedElement.selectedLength, 5)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 31)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 35)
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
        AccessibilityStrategyVisualMode.head = 66
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 61)
        XCTAssertEqual(returnedElement.selectedLength, 7)
        XCTAssertNil(returnedElement.selectedText)
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
        AccessibilityStrategyVisualMode.head = 58
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 57)
        XCTAssertEqual(returnedElement.selectedLength, 6)
        XCTAssertNil(returnedElement.selectedText)
    }

}


// bug found
extension ASUT_VMC_iW__Tests {

    func test_that_when_the_caret_is_on_an_EmptyLine_it_keeps_the_EmptyLine_selected() {
        let text = """
not an empty line

still not an empty
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 37,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 2,
                start: 18,
                end: 19
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 18
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_does_not_get_blocked_by_the_newline_at_the_end_of_a_line() {
        let text = """
shouldn't st-p
at end of line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 11,
            selectedLength: 3,
            selectedText: """
        top
        """,
            fullyVisibleArea: 0..<29,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 1,
                start: 0,
                end: 15
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 11
        AccessibilityStrategyVisualMode.head = 13
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 11)
        XCTAssertEqual(returnedElement.selectedLength, 6)
        XCTAssertNil(returnedElement.selectedText)
    }

}
