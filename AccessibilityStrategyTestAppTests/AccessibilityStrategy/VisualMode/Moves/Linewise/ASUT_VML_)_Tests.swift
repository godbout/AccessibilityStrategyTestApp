import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML_rightParenthesis_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .linewise)
        
        return asVisualMode.rightParenthesis(on: element, state)
    }
   
}


extension ASUT_VML_rightParenthesis_Tests {
    
    func test_that_when_the_lineAtAnchor_is_before_the_lineAtHead_and_the_newLineAtHead_ends_after_the_lineAtHead_then_it_selects_from_the_start_of_the_lineAtAnchor_to_the_end_of_newLineAtHead() {
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
            selectedLength: 35,
            selectedText: """
        type quite some lines
        because hehe

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
        AccessibilityStrategyVisualMode.head = 47
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 13)
        XCTAssertEqual(returnedElement.selectedLength, 58)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 13)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 70)
    }
    
    func test_that_when_the_lineAtAnchor_is_after_the_lineAtHead_and_the_newLineAtHead_ends_before_the_lineAtAnchor_then_it_selects_from_the_start_of_the_newLineAtHead_to_the_end_of_lineAtAnchor() {
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
            selectedLength: 96,
            selectedText: """
        type quite some lines
        because hehe
        that's gonna be
        a not

        so easy one
        hehe
        but actually easy yes
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
        
        AccessibilityStrategyVisualMode.anchor = 108
        AccessibilityStrategyVisualMode.head = 13
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 70)
        XCTAssertEqual(returnedElement.selectedLength, 39)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 108)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 70)
    }

    func test_that_when_the_lineAtAnchor_is_after_the_lineAtHead_and_the_newLineAtHead_ends_after_the_lineAtAnchor_then_it_selects_from_the_start_of_the_lineAtAnchor_to_the_end_of_newLineAtHead() {
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
            selectedLength: 35,
            selectedText: """
        type quite some lines
        because hehe

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
        
        AccessibilityStrategyVisualMode.anchor = 47
        AccessibilityStrategyVisualMode.head = 13
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 35)
        XCTAssertEqual(returnedElement.selectedLength, 36)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 35)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 70)
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
            caretLocation: 48,
            selectedLength: 16,
            selectedText: """
        that's gonna be

        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 4,
                start: 48,
                end: 64
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 48
        AccessibilityStrategyVisualMode.head = 63
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 48)
        XCTAssertEqual(returnedElement.selectedLength, 23)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 48)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 70)
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
            caretLocation: 48,
            selectedLength: 16,
            selectedText: """
        that's gonna be

        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 4,
                start: 48,
                end: 64
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 63
        AccessibilityStrategyVisualMode.head = 48
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 48)
        XCTAssertEqual(returnedElement.selectedLength, 23)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 48)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 70)
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
            caretLocation: 0,
            selectedLength: 94,
            selectedText: """
        here is. some sentence. and more.
        and like we have this.
        and hehe. hard.
        yep. coding is hard.

        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 93
        AccessibilityStrategyVisualMode.head = 0
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 34)
        XCTAssertEqual(returnedElement.selectedLength, 60)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 93)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 34)
    }

}


// bug found
extension ASUT_VML_rightParenthesis_Tests {
    
    func test_some_case_where_it_skips_one_line() {
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
            caretLocation: 0,
            selectedLength: 34,
            selectedText: """
        here is. some sentence. and more.

        """,
            fullyVisibleArea: 0..<109,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 109,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 33
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 57)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 56)
    }
    
}
