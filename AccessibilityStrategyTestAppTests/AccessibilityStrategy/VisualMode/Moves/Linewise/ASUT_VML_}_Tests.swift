import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML_rightBrace_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .linewise)
        
        return asVisualMode.rightBrace(on: element, state)
    }
   
}


extension ASUT_VML_rightBrace_Tests {
    
    func test_that_when_the_lineAtAnchor_is_before_the_lineAtHead_and_the_newLineAtHead_ends_after_the_lineAtHead_then_it_selects_from_the_start_of_the_lineAtAnchor_to_the_end_of_newLineAtHead() {
        let text = """
ok so
those are
paragraphs
hehe


so we need
to test well
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 57,
            caretLocation: 6,
            selectedLength: 21,
            selectedText: """
        those are
        paragraphs

        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 2,
                start: 6,
                end: 16
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 6
        AccessibilityStrategyVisualMode.head = 26
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 6)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 32)
    }
    
    func test_that_when_the_lineAtAnchor_is_after_the_lineAtHead_and_the_newLineAtHead_ends_before_the_lineAtAnchor_then_it_selects_from_the_start_of_the_newLineAtHead_to_the_end_of_lineAtAnchor() {
        let text = """
ok so
those are
paragraphs
hehe


so we need
to test well
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 57,
            caretLocation: 6,
            selectedLength: 39,
            selectedText: """
        those are
        paragraphs
        hehe


        so we need

        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 2,
                start: 6,
                end: 16
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 44
        AccessibilityStrategyVisualMode.head = 6
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 32)
        XCTAssertEqual(returnedElement.selectedLength, 13)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 44)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 32)
    }

    func test_that_when_the_lineAtAnchor_is_after_the_lineAtHead_and_the_newLineAtHead_ends_after_the_lineAtAnchor_then_it_selects_from_the_start_of_the_lineAtAnchor_to_the_end_of_newLineAtHead() {
        let text = """
ok so
those are
paragraphs
hehe


so we need
to test well
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 57,
            caretLocation: 33,
            selectedLength: 12,
            selectedText: """

        so we need

        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 6,
                start: 33,
                end: 34
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 44
        AccessibilityStrategyVisualMode.head = 33
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 34)
        XCTAssertEqual(returnedElement.selectedLength, 23)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 34)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 56)
    }
    
    func test_that_when_the_lineAtAnchor_is_the_same_as_the_lineAtHead_and_the_Anchor_is_before_the_Head_then_it_selects_from_the_start_of_the_lineAtAnchorSlashHead_to_the_end_of_newLineAtHead() {
        let text = """
ok so
those are
paragraphs
hehe


so we need
to test well
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 57,
            caretLocation: 6,
            selectedLength: 10,
            selectedText: """
        those are

        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 2,
                start: 6,
                end: 16
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 6
        AccessibilityStrategyVisualMode.head = 15
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 6)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 32)
    }
    
    func test_that_when_the_lineAtAnchor_is_the_same_as_the_lineAtHead_and_the_Head_is_before_the_Anchor_then_it_selects_from_the_start_of_the_lineAtAnchorSlashHead_to_the_end_of_newLineAtHead() {
        let text = """
ok so
those are
paragraphs
hehe


so we need
to test well
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 57,
            caretLocation: 6,
            selectedLength: 10,
            selectedText: """
        those are

        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 2,
                start: 6,
                end: 16
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 15
        AccessibilityStrategyVisualMode.head = 6
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 6)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 32)
    }

}
