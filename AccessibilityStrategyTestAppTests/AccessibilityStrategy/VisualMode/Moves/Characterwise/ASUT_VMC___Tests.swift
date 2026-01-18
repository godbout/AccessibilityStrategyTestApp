import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC___Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.underscore(times: count, on: element, vimEngineState)
    }
   
}


// count
extension ASUT_VMC___Tests {
    
    func test_it_implements_the_count_system_for_when_the_newHead_is_after_or_equal_to_the_Anchor() {
        let text = """
ok so now we're going
to test that move on
multiline and this
is something for VisualMode
so it's probably gonna
    select some stuff and all
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 142,
            caretLocation: 26,
            selectedLength: 28,
            selectedText: """
        est that move on
        multiline a
        """,
            fullyVisibleArea: 0..<142,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 142,
                number: 2,
                start: 22,
                end: 43
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 53
        AccessibilityStrategyVisualMode.head = 26
        
        let returnedElement = applyMoveBeingTested(times: 5, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 53)
        XCTAssertEqual(returnedElement.selectedLength, 65)
    }
        
    func test_that_it_implements_the_count_system_for_when_the_newHead_is_before_the_Anchor() {
        let text = """
ok so now we're going
to test that move on
multiline and this
is something for VisualMode
so it's probably gonna
select some stuff and all
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 138,
            caretLocation: 25,
            selectedLength: 102,
            selectedText: """
        test that move on
        multiline and this
        is something for VisualMode
        so it's probably gonna
        select some st
        """,
            fullyVisibleArea: 0..<138,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 138,
                number: 2,
                start: 22,
                end: 43
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 126
        AccessibilityStrategyVisualMode.head = 25
        
        let returnedElement = applyMoveBeingTested(times: 5, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 113)
        XCTAssertEqual(returnedElement.selectedLength, 14)
    }
    
    func test_that_if_the_count_is_too_high_it_selects_until_the_firstNonBlank_of_the_lastLine() {
        let text = """
ok so now we're going
to test that move on
multiline and this
is something for VisualMode
so it's probably gonna
select some stuff and all
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 138,
            caretLocation: 4,
            selectedLength: 29,
            selectedText: """
        o now we're going
        to test tha
        """,
            fullyVisibleArea: 0..<138,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 138,
                number: 1,
                start: 0,
                end: 22
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 4
        AccessibilityStrategyVisualMode.head = 32
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 110)
    }
    
}


// TextFields and TextViews
extension ASUT_VMC___Tests {
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_to_the_firstNonBlank_of_the_line_and_extends_the_selection_backwards() {
        let text = "       that's some nice text in here yehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 41,
            caretLocation: 17,
            selectedLength: 15,
            selectedText: "e nice text in ",
            fullyVisibleArea: 0..<41,
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
            fullyVisibleArea: 0..<69,
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
extension ASUT_VMC___Tests {

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
            fullyVisibleArea: 0..<69,
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
            fullyVisibleArea: 0..<126,
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
