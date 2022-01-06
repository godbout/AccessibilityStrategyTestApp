import XCTest
import AccessibilityStrategy


class ASUT_VMC_caret_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.caretForVisualStyleCharacterwise(on: element)
    }
   
}


// Both
extension ASUT_VMC_caret_Tests {
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_to_the_firstNonBlank_of_the_line_and_extends_the_selection_backwards() {
        let text = "       that's some nice text in here yehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 41,
            caretLocation: 17,
            selectedLength: 15,
            selectedText: "e nice text in ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 41,
                number: 1,
                start: 0,
                end: 41
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 31
        AccessibilityStrategyVisualMode.head = 17
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 7)
        XCTAssertEqual(returnedElement.selectedLength, 25)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_after_the_anchor_then_it_goes_to_beginning_of_the_line_by_reducing_the_selection_until_the_anchor_and_extending_it_from_the_anchor_to_the_firstNonBlankLimit_of_the_line() {
        let text = """
0 for visual mode starts
    at the anchor, not at the caret location
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 69,
            caretLocation: 55,
            selectedLength: 5,
            selectedText: "caret",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 69,
                number: 5,
                start: 48,
                end: 61
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 55
        AccessibilityStrategyVisualMode.head = 59

        let returnedElement = applyMoveBeingTested(on: element)
       
        XCTAssertEqual(returnedElement.caretLocation, 29)
        XCTAssertEqual(returnedElement.selectedLength, 27)
    }

}


// TextViews
extension ASUT_VMC_caret_Tests {

    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_before_the_anchor_the_it_goes_to_the_firstNonBlankLimit_of_the_line_and_extends_the_selection() {
        let text = """
  ⛱️e gonna select
over ⛱️⛱️ multiple lines coz
0 has some problems y
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 69,
            caretLocation: 12,
            selectedLength: 28,
            selectedText: "select\nover ⛱️⛱️ multiple li",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 69,
                number: 2,
                start: 12,
                end: 19
            )!
        )
        
        
        AccessibilityStrategyVisualMode.anchor = 39
        AccessibilityStrategyVisualMode.head = 12

        let returnedElement = applyMoveBeingTested(on: element)
       
        XCTAssertEqual(returnedElement.caretLocation, 2)
        XCTAssertEqual(returnedElement.selectedLength, 38)
    }
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_after_the_anchor_then_it_goes_to_the_firstNonBlankLimit_of_the_line_and_reduces_the_selection() {
        let text = """
   we gonna select from top to bottom
  over multiple lines and send 0 on
a line and the caret should to the
start of the line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 126,
            caretLocation: 0,
            selectedLength: 44,
            selectedText: "   we gonna select from top to bottom\nover",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 126,
                number: 1,
                start: 0,
                end: 12
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 43

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 41)
    }

}
