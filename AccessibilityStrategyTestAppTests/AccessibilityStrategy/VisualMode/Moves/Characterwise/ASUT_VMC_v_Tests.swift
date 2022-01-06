import XCTest
import AccessibilityStrategy


class ASUT_VMC_v_Tests: ASVM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.vForVisualStyleCharacterwise(on: element)
    }

}


extension ASUT_VMC_v_Tests {

    func test_that_if_we_were_already_in_VisualMode_Characterwise_when_calling_v_it_sets_the_caret_to_the_head_location_that_will_never_be_behind_the_end_limit() {
        let text = """
entering with v from
VM linewise will set
the caret to the head
if the head is not after the line end limit
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 107,
            caretLocation: 42,
            selectedLength: 9,
            selectedText: "the caret",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 107,
                number: 5,
                start: 42,
                end: 55
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 42
        AccessibilityStrategyVisualMode.head = 50
        
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 50)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }

    func test_that_the_caret_goes_to_the_head_location_even_the_head_is_on_a_different_line_than_the_caret() {
        let text = """
now we gonna have
the⛱️ selection spread over
multiple lines
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 13,
            selectedLength: 10,
            selectedText: "have\nthe⛱️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 2,
                start: 13,
                end: 18
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 13
        AccessibilityStrategyVisualMode.head = 21

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 21)
        XCTAssertEqual(returnedElement.selectedLength, 2)
    }
    
}


// Anchor and Head
extension ASUT_VMC_v_Tests {

    func test_that_it_resets_the_Anchor_and_Head_to_nil() {
        let text = "some bullshit really"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 20,
            caretLocation: 14,
            selectedLength: 6,
            selectedText: "really",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 20,
                number: 3,
                start: 14,
                end: 20
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 14
        AccessibilityStrategyVisualMode.head = 19
        
        _ = applyMoveBeingTested(on: element)
        
        XCTAssertNil(AccessibilityStrategyVisualMode.anchor)
        XCTAssertNil(AccessibilityStrategyVisualMode.head)
    }
        
}
