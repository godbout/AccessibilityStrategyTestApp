import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML_G__Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = nil, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .linewise)
        
        return asVisualMode.G(times: count, on: element, state)
    }

}


// count
extension ASUT_VML_G__Tests {
    
    func test_it_implements_the_count_system_for_when_the_newHead_is_after_or_equal_to_the_Anchor() {
        let text = """
so pressing G in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 0,
            selectedLength: 41,
            selectedText: """
so pressing G in
Visual Mode is gonna be
""",
            visibleCharacterRange: 0..<116,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 1,
                start: 0,
                end: 17
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 40
        
        let returnedElement = applyMoveBeingTested(times: 4, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 83)
    }
        
    func test_that_it_implements_the_count_system_for_when_the_newHead_is_before_the_Anchor() {
        let text = """
so pressing G in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 0,
            selectedLength: 41,
            selectedText: """
so pressing G in
Visual Mode is gonna be
""",
            visibleCharacterRange: 0..<116,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 1,
                start: 0,
                end: 17
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 40
        
        let returnedElement = applyMoveBeingTested(times: 1, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 17)
    }
    
    func test_that_if_the_count_is_nil_it_selects_until_the_end_of_the_text() {
        let text = """
so pressing G in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 0,
            selectedLength: 41,
            selectedText: """
so pressing G in
Visual Mode is gonna be
""",
            visibleCharacterRange: 0..<116,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 1,
                start: 0,
                end: 17
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 40
        AccessibilityStrategyVisualMode.head = 0
        
        let returnedElement = applyMoveBeingTested(times: nil, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 99)
    }
        
    func test_that_if_the_count_is_too_high_it_selects_until_the_end_of_the_text() {
        let text = """
so pressing G in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 0,
            selectedLength: 41,
            selectedText: """
so pressing G in
Visual Mode is gonna be
""",
            visibleCharacterRange: 0..<116,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 1,
                start: 0,
                end: 17
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 40
        AccessibilityStrategyVisualMode.head = 0
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 99)
    }
    
}


// Both
extension ASUT_VML_G__Tests {
    
    func test_that_if_the_TextElement_is_just_a_single_line_then_it_keeps_the_whole_line_selected() {
        let text = "        so here we gonna test VG"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 32,
            caretLocation: 0,
            selectedLength: 32,
            selectedText: "        so here we gonna test VG",
            visibleCharacterRange: 0..<32,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 1,
                start: 0,
                end: 32
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 31

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 32)
    }
    
}


// TextViews
extension ASUT_VML_G__Tests {
    
    func test_that_if_the_head_is_after_or_at_the_same_line_as_the_anchor_then_it_selects_from_the_anchor_to_the_end_of_the_text() {
        let text = """
so now this is gonna
😂️ be a longer one
and we're gonna
select until
the end
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 77,
            caretLocation: 21,
            selectedLength: 20,
            selectedText: "😂️ be a longer one\n",
            visibleCharacterRange: 0..<77,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 3,
                start: 21,
                end: 30
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 21
        AccessibilityStrategyVisualMode.head = 40

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement.caretLocation, 21)
        XCTAssertEqual(accessibilityElement.selectedLength, 56)
    }
    
    func test_that_if_the_head_is_before_the_line_of_the_anchor_then_it_selects_from_the_anchor_to_the_end_of_the_text() {
        let text = """
so now this is gonna
😂️ be a longer one
and we're gonna
select until
the end
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 77,
            caretLocation: 21,
            selectedLength: 36,
            selectedText: "😂️ be a longer one\nand we're gonna\n",
            visibleCharacterRange: 0..<77,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 3,
                start: 21,
                end: 30
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 56
        AccessibilityStrategyVisualMode.head = 21

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement.caretLocation, 41)
        XCTAssertEqual(accessibilityElement.selectedLength, 36)
    }
    
}
