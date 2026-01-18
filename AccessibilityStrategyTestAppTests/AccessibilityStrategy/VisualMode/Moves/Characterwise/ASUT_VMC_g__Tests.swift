import XCTest
import AccessibilityStrategy
import Common


// by its nature these tests will contain blanks.
class ASUT_VMC_g__Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.gUnderscore(times: count, on: element, vimEngineState)
    }
    
}


// line
extension ASUT_VMC_g__Tests {
    
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
            fullyVisibleArea: 0..<115,
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

        XCTAssertEqual(returnedElement.caretLocation, 11)
        XCTAssertEqual(returnedElement.selectedLength, 50)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_VMC_g__Tests {
    
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
            length: 144,
            caretLocation: 26,
            selectedLength: 28,
            selectedText: """
        est that move on
        multiline a
        """,
            fullyVisibleArea: 0..<144,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 144,
                number: 2,
                start: 22,
                end: 43
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 53
        AccessibilityStrategyVisualMode.head = 26
        
        let returnedElement = applyMoveBeingTested(times: 4, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 53)
        XCTAssertEqual(returnedElement.selectedLength, 59)
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
                fullTextLength: 141,
                number: 2,
                start: 22,
                end: 43
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 126
        AccessibilityStrategyVisualMode.head = 25
        
        let returnedElement = applyMoveBeingTested(times: 5, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 126)
        XCTAssertEqual(returnedElement.selectedLength, 12)
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
                fullTextLength: 141,
                number: 1,
                start: 0,
                end: 22
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 4
        AccessibilityStrategyVisualMode.head = 32
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 134)
    }
    
}


// TextFields and TextViews
extension ASUT_VMC_g__Tests {
            
    func test_that_if_the_selection_spans_over_a_single_line_and_the_Head_is_after_the_Anchor_then_it_goes_to_the_lastNonBlank_of_the_line_and_extends_the_selection() {
        let text = "hello world     "
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 16,
            caretLocation: 5,
            selectedLength: 1,
            selectedText: """
         
        """,
            fullyVisibleArea: 0..<16,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 16,
                number: 1,
                start: 0,
                end: 16
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 5
        AccessibilityStrategyVisualMode.head = 5
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 5)
        XCTAssertEqual(returnedElement.selectedLength, 6)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_Head_is_before_the_Anchor_then_it_goes_to_the_lastNonBlank_of_the_line_and_reduces_the_selection_until_the_Anchor_and_then_extends_it_after() {
        let text = """
$ for visual mode starts
at the anchor, not at the caret location    
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 69,
            caretLocation: 51,
            selectedLength: 7,
            selectedText: """
        caret l
        """,
            fullyVisibleArea: 0..<69,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 69,
                number: 2,
                start: 25,
                end: 69
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 57
        AccessibilityStrategyVisualMode.head = 51
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 57)
        XCTAssertEqual(returnedElement.selectedLength, 8)
    }
    
}


// TextViews
extension ASUT_VMC_g__Tests {
    
    func test_that_if_line_ends_with_linefeed_it_goes_to_the_lastNonBlank_of_the_line_still() {
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
            fullyVisibleArea: 0..<24,
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
                
        XCTAssertEqual(returnedElement.caretLocation, 12)
        XCTAssertEqual(returnedElement.selectedLength, 2)
    }
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_Head_is_after_the_Anchor_then_it_goes_to_the_lastNonBlank_of_the_line_where_the_head_is_located_and_extends_the_selection() {
        let text = """
we gonna select
over multiple lines coz
$ not work ⛱️⛱️LOOOL       
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 67,
            caretLocation: 36,
            selectedLength: 5,
            selectedText: """
        coz
        $
        """,
            fullyVisibleArea: 0..<67,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 67,
                number: 2,
                start: 16,
                end: 40
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 35
        AccessibilityStrategyVisualMode.head = 40

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 35)
        XCTAssertEqual(returnedElement.selectedLength, 25)
    }

    func test_that_if_the_selection_spans_over_multiple_lines_and_the_Head_is_before_the_Anchor_then_it_goes_to_the_lastNonBlank_of_the_line_where_the_Head_is_located_and_reduces_the_selection() {
        let text = """
we gonna select
over multiple lines coz
$ doesn't work LOOOLL    
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 65,
            caretLocation: 31,
            selectedLength: 30,
            selectedText: """
        ines coz
        $ doesn't work LOOOLL
        """,
            fullyVisibleArea: 0..<65,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 65,
                number: 2,
                start: 16,
                end: 40
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 60
        AccessibilityStrategyVisualMode.head = 31
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 38)
        XCTAssertEqual(returnedElement.selectedLength, 23)
    }
    
}
