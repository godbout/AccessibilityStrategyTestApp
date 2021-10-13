import XCTest
import AccessibilityStrategy


class ASUT_VML_gg_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.ggForVisualStyleLinewise(on: element)
    }

}


// Both
extension ASUT_VML_gg_Tests {
    
    func test_that_if_the_TextElement_is_just_a_single_line_then_it_keeps_the_whole_line_selected() {
        let text = "        so here we gonna test Vgg"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 33,
            caretLocation: 0,
            selectedLength: 33,
            selectedText: "        so here we gonna test Vgg",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 33,
                number: 1,
                start: 0,
                end: 33
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 32

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 33)
    }
    
}


// TextViews
extension ASUT_VML_gg_Tests {

    func test_that_if_the_head_is_after_the_line_of_the_anchor_then_it_selects_from_the_anchor_to_the_beginning_of_the_text() {
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
            caretLocation: 41,
            selectedLength: 29,
            selectedText: "and we're gonna\nselect until\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 5,
                start: 41,
                end: 51
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 41
        AccessibilityStrategyVisualMode.head = 69

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 57)
    }
    
    func test_that_if_the_head_is_before_or_at_the_same_line_as_the_anchor_then_it_selects_from_the_anchor_to_the_beginning_of_the_text() {
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
            caretLocation: 41,
            selectedLength: 29,
            selectedText: "and we're gonna\nselect until\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 5,
                start: 41,
                end: 51
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 69
        AccessibilityStrategyVisualMode.head = 41

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 70)
    }
    
}
