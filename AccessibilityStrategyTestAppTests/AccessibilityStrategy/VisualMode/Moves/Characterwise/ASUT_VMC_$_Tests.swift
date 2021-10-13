import XCTest
import AccessibilityStrategy


class ASUT_VMC_$_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.dollarSignForVisualStyleCharacterwise(on: element)
    }
    
}


// line
extension ASUT_VMC_$_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 11,
            selectedLength: 9,
            selectedText: "oes not s",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 10,
                end: 19
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 11
        AccessibilityStrategyVisualMode.head = 19
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 11)
        XCTAssertEqual(returnedElement?.selectedLength, 51)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}


// Both
extension ASUT_VMC_$_Tests {
            
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_after_the_anchor_then_it_goes_to_the_end_of_the_line_and_extends_the_selection() {
        let text = "hello world"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 11,
            caretLocation: 5,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 11,
                number: 1,
                start: 0,
                end: 11
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 5
        AccessibilityStrategyVisualMode.head = 5
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 5)
        XCTAssertEqual(returnedElement?.selectedLength, 6)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_to_the_end_of_the_line_and_reduces_the_selection_until_the_anchor_and_then_extends_it_after() {
        let text = """
$ for visual mode starts
at the anchor, not at the caret location
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 65,
            caretLocation: 51,
            selectedLength: 7,
            selectedText: "caret l",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 65,
                number: 5,
                start: 44,
                end: 57
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 57
        AccessibilityStrategyVisualMode.head = 51
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 57)
        XCTAssertEqual(returnedElement?.selectedLength, 8)
    }
    
    func test_that_it_sets_the_ATE_globalColumnNumber_to_nil() {
        let text = """
when using $
the globalColumnNumber
is set to nil so that next
j or k will go to the line endLimit
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 98,
            caretLocation: 18,
            selectedLength: 34,
            selectedText: "lobalColumnNumber\nis set to nil so",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 98,
                number: 3,
                start: 17,
                end: 29
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 51
        
        AccessibilityTextElement.globalColumnNumber = 17
        
        _ = applyMoveBeingTested(on: element)

        XCTAssertNil(AccessibilityTextElement.globalColumnNumber)
    }
    
}


// TextViews
extension ASUT_VMC_$_Tests {
    
    func test_that_if_line_ends_with_linefeed_it_goes_to_the_end_of_the_line_still() {
        let text = """
indeed
that is
multiline
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 24,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 24,
                number: 2,
                start: 7,
                end: 15
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 12
        AccessibilityStrategyVisualMode.head = 12
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement?.caretLocation, 12)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
    }
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_after_the_anchor_then_it_goes_to_the_end_of_the_line_where_the_head_is_located_and_extends_the_selection() {
        let text = """
we gonna select
over multiple lines coz
$ not work ⛱️⛱️LOOOL
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 35,
            selectedLength: 6,
            selectedText: " coz\n$",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 5,
                start: 30,
                end: 40
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 35
        AccessibilityStrategyVisualMode.head = 40

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 35)
        XCTAssertEqual(returnedElement?.selectedLength, 25)
    }

    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_before_the_anchor_then_it_goes_to_the_end_of_the_line_where_the_head_is_located_and_reduces_the_selection() {
        let text = """
we gonna select
over multiple lines coz
$ doesn't work LOOOLL
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 61,
            caretLocation: 31,
            selectedLength: 30,
            selectedText: "ines coz\n$ doesn't work LOOOLL",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 61,
                number: 5,
                start: 30,
                end: 40
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 60
        AccessibilityStrategyVisualMode.head = 31
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 39)
        XCTAssertEqual(returnedElement?.selectedLength, 22)
    }
    
}
