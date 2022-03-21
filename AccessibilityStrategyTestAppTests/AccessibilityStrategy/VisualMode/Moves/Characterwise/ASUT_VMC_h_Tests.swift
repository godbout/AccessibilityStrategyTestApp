import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_h_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .characterwise)
                
        return asVisualMode.h(times: count, on: element, state)
    }

}


// line
extension ASUT_VMC_h_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
  this move stops at screen lines, which         🇧🇶️eans it will
  stop even without a linefeed. that's         how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 132,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "l",
            visibleCharacterRange: 0..<132,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 132,
                number: 4,
                start: 28,
                end: 49
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 28
        AccessibilityStrategyVisualMode.head = 28
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 27)
        XCTAssertEqual(returnedElement.selectedLength, 2)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_VMC_h_Tests {
    
    func test_that_it_implements_the_count_system_for_when_the_Head_is_after_or_equal_to_the_Anchor() {
        let text = "we gonna move in there with count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 17,
            selectedLength: 10,
            selectedText: "there with",
            visibleCharacterRange: 0..<42,
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
                
        let returnedElement = applyMoveBeingTested(times: 15, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 11)
        XCTAssertEqual(returnedElement.selectedLength, 7)
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
            visibleCharacterRange: 0..<42,
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

        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 18)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_stops_at_the_start_limit_if_the_count_goes_above_it() {
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
            visibleCharacterRange: 0..<42,
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

        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 6)
        XCTAssertNil(returnedElement.selectedText)
    }
}


// Both
extension ASUT_VMC_h_Tests {
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_after_the_anchor_then_it_goes_towards_the_beginning_of_the_line_and_reduces_the_selection_by_one() {
        let text = "hello wo🌍️rld"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 14,
            caretLocation: 5,
            selectedLength: 9,
            selectedText: " wo🌍️rld",
            visibleCharacterRange: 0..<14,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 14,
                number: 1,
                start: 0,
                end: 14
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 5
        AccessibilityStrategyVisualMode.head = 13
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 5)
        XCTAssertEqual(returnedElement.selectedLength, 8)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_towards_the_beginning_of_the_line_and_extends_the_selection_by_one() {
        let text = """
here is some text for VM h
with head before anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 50,
            caretLocation: 37,
            selectedLength: 8,
            selectedText: "before a",
            visibleCharacterRange: 0..<50,
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
                
        XCTAssertEqual(returnedElement.caretLocation, 36)
        XCTAssertEqual(returnedElement.selectedLength, 9)
    }
    
}


// TextViews
extension ASUT_VMC_h_Tests {
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_before_the_anchor_then_it_goes_towards_the_beginning_of_the_line_and_extends_the_selection() {
        let text = """
span over multiple lines
with head before anchor
for VM h
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 57,
            caretLocation: 19,
            selectedLength: 14,
            selectedText: "lines\nwith hea",
            visibleCharacterRange: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 3,
                start: 19,
                end: 25
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 32
        AccessibilityStrategyVisualMode.head = 19
      
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 15)
    }
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_after_the_anchor_then_it_goes_towards_the_beginning_of_the_line_and_reduces_the_selection() {
        let text = """
span over multiple lines
with head after anchor
for VM h and that should
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 72,
            caretLocation: 0,
            selectedLength: 29,
            selectedText: "span over multiple lines\nwith",
            visibleCharacterRange: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 1,
                start: 0,
                end: 10
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 28

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 28)
    }
    
    func test_that_it_stops_at_the_beginning_of_lines_and_does_not_continue_moving_backward_on_the_previous_lines() {
        let text = """
span over multiple lines
w askljaslkasdlfjak
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 0,
            selectedLength: 26,
            selectedText: "span over multiple lines\nw",
            visibleCharacterRange: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 10
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 25

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 26)
    }
    
}
