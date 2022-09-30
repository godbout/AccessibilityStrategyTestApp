import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML_leftBrace_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .linewise)
        
        return asVisualMode.leftBrace(on: element, state)
    }
   
}


extension ASUT_VML_leftBrace_Tests {
    
    func test_that_when_the_lineAtAnchor_is_before_the_lineAtHead_and_the_newLineAtHead_ends_after_the_lineAtAnchor_then_it_selects_from_the_start_of_the_lineAtAnchor_to_the_end_of_newLineAtHead() {
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
        
        AccessibilityStrategyVisualMode.anchor = 6
        AccessibilityStrategyVisualMode.head = 44
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 28)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 6)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 33)
    }
    
    func test_that_when_the_lineAtAnchor_is_before_the_lineAtHead_and_the_newLineAtHead_ends_before_the_lineAtAnchor_then_it_selects_from_the_start_of_the_newLineAtHead_to_the_end_of_lineAtAnchor() {
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
            caretLocation: 34,
            selectedLength: 23,
            selectedText: """
        so we need
        to test well
        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 7,
                start: 34,
                end: 45
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 34
        AccessibilityStrategyVisualMode.head = 56
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 44)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 33)
    }

    func test_that_when_the_lineAtAnchor_is_after_the_lineAtHead_and_the_newLineAtHead_ends_before_the_lineAtHead_then_it_selects_from_the_start_of_the_newLineAtHead_to_the_end_of_lineAtAnchor() {
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
            caretLocation: 34,
            selectedLength: 23,
            selectedText: """
        so we need
        to test well
        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 7,
                start: 34,
                end: 45
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 56
        AccessibilityStrategyVisualMode.head = 34
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 24)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 56)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 33)
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
            caretLocation: 27,
            selectedLength: 5,
            selectedText: """
        hehe

        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 4,
                start: 27,
                end: 32
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 27
        AccessibilityStrategyVisualMode.head = 31
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 32)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 31)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 0)
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
            caretLocation: 27,
            selectedLength: 5,
            selectedText: """
        hehe

        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 4,
                start: 27,
                end: 32
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 31
        AccessibilityStrategyVisualMode.head = 27
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 32)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 31)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 0)
    }

}
