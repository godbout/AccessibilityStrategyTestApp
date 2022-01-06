import XCTest
import AccessibilityStrategy


class ASUT_VML_V__Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.VForVisualStyleLinewise(on: element)
    }

}


// TextAreas
extension ASUT_VML_V__Tests {
       
    func test_that_if_we_were_already_in_VisualMode_Linewise_when_calling_V_it_sets_the_caret_to_the_end_limit_even_when_the_head_happened_to_be_after_the_end_limit() {
        let text = """
yeah we gonna
switch the head and the
anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 14,
            selectedLength: 24,
            selectedText: "switch the head and the\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 3,
                start: 14,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 14
        AccessibilityStrategyVisualMode.head = 37
       
        let returnedElement = applyMoveBeingTested(on: element)
       
        XCTAssertEqual(returnedElement.caretLocation, 36)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }

    func test_that_the_caret_goes_to_the_head_location_after_having_being_switched_when_coming_from_Visual_Mode_linewise() {
        let text = """
yeah we gonna
switch the head and the
anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 14,
            selectedLength: 24,
            selectedText: "switch the head and the\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 3,
                start: 14,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 37
        AccessibilityStrategyVisualMode.head = 14
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }

    func test_that_the_caret_goes_to_the_head_location_even_the_head_is_on_a_different_line_than_the_caret() {
        let text = """
now we gonna have
the selection spread ove⛱️
multiple lines
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 59,
            caretLocation: 0,
            selectedLength: 45,
            selectedText: "now we gonna have\nthe selection spread ove⛱️\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 59,
                number: 1,
                start: 0,
                end: 13
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 44
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 42)
        XCTAssertEqual(returnedElement.selectedLength, 2)
    }

}


// Anchor and Head
extension ASUT_VML_V__Tests {

    func test_that_it_resets_the_Anchor_and_Head_to_nil() {
        let text = """
some bullshit again
really
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 26,
            caretLocation: 20,
            selectedLength: 6,
            selectedText: "really",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 26,
                number: 4,
                start: 20,
                end: 26
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 20
        AccessibilityStrategyVisualMode.head = 25

        _ = applyMoveBeingTested(on: element)
        
        XCTAssertNil(AccessibilityStrategyVisualMode.anchor)
        XCTAssertNil(AccessibilityStrategyVisualMode.head)
    }
        
}
