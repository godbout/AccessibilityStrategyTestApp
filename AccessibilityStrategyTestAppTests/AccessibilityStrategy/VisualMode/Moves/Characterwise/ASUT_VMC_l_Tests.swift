import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_l_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.l(times: count, on: element, vimEngineState)
    }

}


// line
extension ASUT_VMC_l_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
  this move stops at screen lines, which         🇧🇶️eans it will
  stop even without a linefeed. that's         how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 132,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<132,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 132,
                number: 3,
                start: 21,
                end: 28
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 27
        AccessibilityStrategyVisualMode.head = 27
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 27)
        XCTAssertEqual(returnedElement.selectedLength, 2)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_VMC_l_Tests {
    
    func test_that_it_implements_the_count_system_for_when_the_Head_is_after_or_equal_to_the_Anchor() {
        let text = "we gonna move in there with count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 17,
            selectedLength: 10,
            selectedText: "there with",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 17
        AccessibilityStrategyVisualMode.head = 26
                
        let returnedElement = applyMoveBeingTested(times: 8, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 20)
        XCTAssertNil(returnedElement.selectedText)
    }
        
    func test_that_it_implements_the_count_system_for_when_the_Head_is_before_the_Anchor() {
        let text = "we gonna move in there with count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 17,
            selectedLength: 10,
            selectedText: "there with",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 26
        AccessibilityStrategyVisualMode.head = 17
                
        let returnedElement = applyMoveBeingTested(times: 8, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 25)
        XCTAssertEqual(returnedElement.selectedLength, 2)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_it_stops_after_the_linefeed() {
        let text = """
we gonna move
in there with
count 🈹️ awww
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 19,
            selectedLength: 5,
            selectedText: "ere w",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 2,
                start: 14,
                end: 28
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 19
        AccessibilityStrategyVisualMode.head = 23
                
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 9)
        XCTAssertNil(returnedElement.selectedText)
    }
}


// Both
extension ASUT_VMC_l_Tests {
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_after_the_anchor_then_it_goes_towards_the_end_of_the_line_and_extends_the_selection_by_one() {
        let text = "hello👋️ world"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 14,
            caretLocation: 0,
            selectedLength: 5,
            selectedText: "hello",
            fullyVisibleArea: 0..<14,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 14,
                number: 1,
                start: 0,
                end: 14
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 4

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 8)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_towards_the_end_of_the_line_and_extends_the_selection_by_one() {
        let text = """
here is some text for VM l
with head before anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 50,
            caretLocation: 37,
            selectedLength: 8,
            selectedText: "before a",
            fullyVisibleArea: 0..<50,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 5,
                start: 37,
                end: 44
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 44
        AccessibilityStrategyVisualMode.head = 37

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 38)
        XCTAssertEqual(returnedElement.selectedLength, 7)
    }
    
}


// TextViews
extension ASUT_VMC_l_Tests {
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_after_the_anchor_then_it_goes_towards_the_end_of_the_line_and_extends_the_selection() {
        let text = """
span over multiple lines
with head after anchor
for VM l
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 0,
            selectedLength: 29,
            selectedText: "span over multiple lines\nwith",
            fullyVisibleArea: 0..<56,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 1,
                start: 0,
                end: 10
            )!
        )
    
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 28

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 30)
    }
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_before_the_anchor_then_it_goes_towards_the_end_of_the_line_and_reduces_the_selection() {
        let text = """
span over multiple lines
with head before anchor
for VM l and that should
"""
        
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 73,
            caretLocation: 19,
            selectedLength: 29,
            selectedText: "lines\nwith head before anchor",
            fullyVisibleArea: 0..<73,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 73,
                number: 3,
                start: 19,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 47
        AccessibilityStrategyVisualMode.head = 19

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 28)
    }
    
    func test_that_it_stops_at_the_end_of_lines_and_does_not_continue_moving_forward_on_the_next_lines_when_it_is_already_coming_from_a_line_above() {
        let text = """
span over multiple lines
w askljaslkasdlfjak
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 24,
            selectedLength: 20,
            selectedText: "\nw askljaslkasdlfjak",
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 3,
                start: 19,
                end: 25
            )!
        )
    
        AccessibilityStrategyVisualMode.anchor = 43
        AccessibilityStrategyVisualMode.head = 24

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 24)
        XCTAssertEqual(returnedElement.selectedLength, 20)
    }
    
}
