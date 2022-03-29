import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_G__Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = nil, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.G(times: count, on: element, state)
    }

}


// count
extension ASUT_VMC_G__Tests {
    
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
            length: 119,
            caretLocation: 7,
            selectedLength: 23,
            selectedText: """
sing G in
Visual Mode i
""",
            fullyVisibleArea: 0..<119,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 1,
                start: 0,
                end: 17
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 29
        AccessibilityStrategyVisualMode.head = 7
        
        let returnedElement = applyMoveBeingTested(times: 4, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 29)
        XCTAssertEqual(returnedElement.selectedLength, 44)
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
            caretLocation: 21,
            selectedLength: 77,
            selectedText: """
al Mode is gonna be
cool because it will extend
the selection
when the head i
""",
            fullyVisibleArea: 0..<116,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 2,
                start: 17,
                end: 41
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 97
        AccessibilityStrategyVisualMode.head = 21
        
        let returnedElement = applyMoveBeingTested(times: 2, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 81)
    }
    
    func test_that_if_the_count_is_nil_it_selects_until_the_firstNonBlank_of_the_lastFileLine() {
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
            length: 119,
            caretLocation: 21,
            selectedLength: 38,
            selectedText: """
al Mode is gonna be
cool because it wi
""",
            fullyVisibleArea: 0..<119,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 2,
                start: 17,
                end: 41
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 21
        AccessibilityStrategyVisualMode.head = 58
        
        let returnedElement = applyMoveBeingTested(times: nil, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 21)
        XCTAssertEqual(returnedElement.selectedLength, 66)
    }
        
    func test_that_if_the_count_is_too_high_it_selects_until_the_firstNonBlank_of_the_lastFileLine() {
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
            length: 119,
            caretLocation: 21,
            selectedLength: 38,
            selectedText: """
al Mode is gonna be
cool because it wi
""",
            fullyVisibleArea: 0..<119,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 2,
                start: 17,
                end: 41
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 21
        AccessibilityStrategyVisualMode.head = 58
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 21)
        XCTAssertEqual(returnedElement.selectedLength, 66)
    }
    
}


// Both
extension ASUT_VMC_G__Tests {

    // this only happens if the new head location and the anchor are on the same line!
    func test_that_if_the_new_head_location_is_before_the_anchor_then_it_selects_from_the_new_head_location_until_the_anchor() {
        let text = "        💩️o here we 💩️ gonna test vG"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 38,
            caretLocation: 31,
            selectedLength: 6,
            selectedText: "test v",
            fullyVisibleArea: 0..<38,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 1,
                start: 0,
                end: 38
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 36
        AccessibilityStrategyVisualMode.head = 31

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 29)
    }

}


// TextViews
extension ASUT_VMC_G__Tests {
    
    func test_that_if_the_new_head_location_is_after_the_anchor_then_it_selects_from_anchor_to_the_new_head_location() {
        let text = """
we gonna put the caret before
the anchor and do
the move and it should
     all work fine
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 89,
            caretLocation: 17,
            selectedLength: 30,
            selectedText: "caret before\nthe anchor and do",
            fullyVisibleArea: 0..<89,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 89,
                number: 2,
                start: 13,
                end: 23
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 46
        AccessibilityStrategyVisualMode.head = 17

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 46)
        XCTAssertEqual(returnedElement.selectedLength, 31)
    }
    
}
