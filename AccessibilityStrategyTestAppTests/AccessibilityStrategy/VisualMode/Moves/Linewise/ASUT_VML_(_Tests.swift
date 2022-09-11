import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML_leftParenthesis_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .linewise)
        
        return asVisualMode.leftParenthesis(on: element, state)
    }
   
}


extension ASUT_VML_leftParenthesis_Tests {
    
    func test_that_when_the_lineAtAnchor_is_before_the_lineAtHead_and_the_newLineAtHead_ends_after_the_lineAtAnchor_then_it_selects_from_the_start_of_the_lineAtAnchor_to_the_end_of_newLineAtHead() {
        let text = """
now we gonna
type quite some lines
because hehe
that's gonna be
a not

so easy one
hehe
but actually easy yes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 109,
            caretLocation: 13,
            selectedLength: 75,
            selectedText: """
        type quite some lines
        because hehe
        that's gonna be
        a not

        so easy one
        hehe

        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 2,
                start: 13,
                end: 35
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 13
        AccessibilityStrategyVisualMode.head = 87
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 13)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 82)
        XCTAssertEqual(returnedElement.caretLocation, 13)
        XCTAssertEqual(returnedElement.selectedLength, 70)
    }
    
    func test_that_when_the_lineAtAnchor_is_before_the_lineAtHead_and_the_newLineAtHead_ends_before_the_lineAtAnchor_then_it_selects_from_the_start_of_the_newLineAtHead_to_the_end_of_lineAtAnchor() {
        let text = """
now we gonna
type quite some lines
because hehe
that's gonna be
a not

so easy one
hehe
but actually easy yes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 109,
            caretLocation: 35,
            selectedLength: 36,
            selectedText: """
        because hehe
        that's gonna be
        a not


        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 3,
                start: 35,
                end: 48
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 35
        AccessibilityStrategyVisualMode.head = 70
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 47)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 0)
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 48)
    }

    func test_that_when_the_lineAtAnchor_is_after_the_lineAtHead_and_the_newLineAtHead_ends_before_the_lineAtHead_then_it_selects_from_the_start_of_the_newLineAtHead_to_the_end_of_lineAtAnchor() {
        let text = """
now we gonna
type quite some lines
because hehe
that's gonna be
a not

so easy one
hehe
but actually easy yes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 109,
            caretLocation: 35,
            selectedLength: 35,
            selectedText: """
        because hehe
        that's gonna be
        a not

        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 3,
                start: 35,
                end: 48
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 69
        AccessibilityStrategyVisualMode.head = 35
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 69)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 0)
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 70)
    }
    
    func test_that_when_the_lineAtAnchor_is_the_same_as_the_lineAtHead_and_the_Anchor_is_before_the_Head_then_it_selects_from_the_start_of_the_lineAtAnchorSlashHead_to_the_end_of_newLineAtHead() {
        let text = """
now we gonna
type quite some lines
because hehe
that's gonna be
a not

so easy one
hehe
but actually easy yes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 109,
            caretLocation: 83,
            selectedLength: 5,
            selectedText: """
        hehe

        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 8,
                start: 83,
                end: 88
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 83
        AccessibilityStrategyVisualMode.head = 87
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 87)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 71)
        XCTAssertEqual(returnedElement.caretLocation, 71)
        XCTAssertEqual(returnedElement.selectedLength, 17)
    }
    
    func test_that_when_the_lineAtAnchor_is_the_same_as_the_lineAtHead_and_the_Head_is_before_the_Anchor_then_it_selects_from_the_start_of_the_lineAtAnchorSlashHead_to_the_end_of_newLineAtHead() {
        let text = """
now we gonna
type quite some lines
because hehe
that's gonna be
a not

so easy one
hehe
but actually easy yes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 109,
            caretLocation: 83,
            selectedLength: 5,
            selectedText: """
        hehe

        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 8,
                start: 83,
                end: 88
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 87
        AccessibilityStrategyVisualMode.head = 83
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 87)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 71)
        XCTAssertEqual(returnedElement.caretLocation, 71)
        XCTAssertEqual(returnedElement.selectedLength, 17)
    }
    
    func test_on_a_text_with_sentences_on_a_same_line_not_like_code() {
        let text = """
here is. some sentence. and more.
and like we have this.
and hehe. hard.
yep. coding is hard.
vim even. more.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 109,
            caretLocation: 57,
            selectedLength: 16,
            selectedText: """
        and hehe. hard.

        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 3,
                start: 57,
                end: 73
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 57
        AccessibilityStrategyVisualMode.head = 72
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 72)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 34)
        XCTAssertEqual(returnedElement.caretLocation, 34)
        XCTAssertEqual(returnedElement.selectedLength, 39)
    }

}


// bug found
extension ASUT_VML_leftParenthesis_Tests {
    
    func test_some_case_where_the_caret_would_get_stuck() {
        let text = """
now we gonna
type quite some lines
because hehe
that's gonna be
a not

so easy one
hehe
but actually easy yes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 109,
            caretLocation: 35,
            selectedLength: 48,
            selectedText: """
        because hehe
        that's gonna be
        a not

        so easy one

        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 3,
                start: 35,
                end: 48
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 35
        AccessibilityStrategyVisualMode.head = 82
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 35)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 70)
        XCTAssertEqual(returnedElement.caretLocation, 35)
        XCTAssertEqual(returnedElement.selectedLength, 36)
    }
    
}
