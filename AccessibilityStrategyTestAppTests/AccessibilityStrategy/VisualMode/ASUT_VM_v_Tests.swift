import XCTest
import AccessibilityStrategy
import Common


// see `V` for blah blah
class ASUT_VM_v_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.vFromNormalMode(on: element)
    }
    
}


extension ASUT_VM_v_Tests {
    
    func test_that_if_we_just_entered_VisualMode_with_v_from_NormalMode_it_sets_the_anchor_and_head_to_the_caret_location() {
        let text = """
entering with v from
normal mode 😀️eans anchor
and head are nil
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 64,
            caretLocation: 33,
            selectedLength: 3,
            selectedText: "😀️",
            visibleCharacterRange: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 4,
                start: 33,
                end: 41
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 33)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 33)
    }
    
    func test_that_if_we_just_entered_VisualMode_with_v_from_NormalMode_and_the_caret_location_is_over_the_line_end_limit_then_it_sets_the_caret_anchor_and_head_to_the_line_end_limit() {
        let text = """
entering with v from
normal mode but with
caret out of boundaries
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 65,
            caretLocation: 40,
            selectedLength: 1,
            selectedText: "h",
            visibleCharacterRange: 0..<65,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 65,
                number: 4,
                start: 33,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
       
        XCTAssertEqual(returnedElement.caretLocation, 40)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 40)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 40)
    }
    
    // only tested for vForEnteringFromNormalMode but done for all vs and Vs.
    // not tested because UI Tests are expensive, and it's a small thing. but adding this comment
    // because it's good to be reminded of it.
    func test_that_entering_VisualMode_with_v_from_NormalMode_does_not_override_the_screenLineColumnNumber() {
        let text = """
if we $ before entering VM the GCN
should still stay at nil
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 59,
            caretLocation: 58,
            selectedLength: 1,
            selectedText: "l",
            visibleCharacterRange: 0..<59,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 59,
                number: 6,
                start: 48,
                end: 59
            )!
        )
        
        // setting it manually here as this is not a UI test,
        // so the selectedLength didSet is not called.
        AccessibilityTextElement.screenLineColumnNumber = 23
        
        _ = applyMoveBeingTested(on: element)
       
        XCTAssertEqual(AccessibilityTextElement.screenLineColumnNumber, 23)
    }

}
