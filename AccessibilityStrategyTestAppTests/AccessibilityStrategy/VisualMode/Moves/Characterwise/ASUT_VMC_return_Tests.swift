import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_return_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(visualStyle: .characterwise)
            
        return applyMoveBeingTested(times: count, on: element, &state)
    }
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        vimEngineState.visualStyle = .characterwise
        
        return asVisualMode.`return`(times: count, on: element, &vimEngineState)
    }

}
    

// TextFields
// see VML for blah blah


// Bip
extension ASUT_VMC_return_Tests {
    
    func test_that_if_the_head_is_at_the_last_line_then_it_bips() {
        let text = """
well last line
or TV 🍍️
or a TF same same
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 18,
            selectedLength: 17,
            selectedText: "TV 🍍️\nor a TF sa",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 2,
                start: 15,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 34
                
        var state = VimEngineState(lastMoveBipped: false)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertTrue(state.lastMoveBipped)
    }

}


// count
extension ASUT_VMC_return_Tests {
    
    func test_it_implements_the_count_system_for_when_the_newHead_is_after_or_equal_to_the_Anchor() {
        let text = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
  🍅️he wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 123,
            caretLocation: 6,
            selectedLength: 14,
            selectedText: "at one is gonn",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 123,
                number: 1,
                start: 0,
                end: 41
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 19
        AccessibilityStrategyVisualMode.head = 6
        
        let returnedElement = applyMoveBeingTested(times: 2, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 65)
    }
        
    func test_that_it_implements_the_count_system_for_when_the_newHead_is_before_the_Anchor() {
        let text = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
  🍅️he wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 123,
            caretLocation: 9,
            selectedLength: 91,
            selectedText: """
one is gonna rip my ass off lol
and it's getting even harder now that
  🍅️he wrapped lines
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 123,
                number: 1,
                start: 0,
                end: 41
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 99
        AccessibilityStrategyVisualMode.head = 9
        
        let returnedElement = applyMoveBeingTested(times: 2, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 81)
        XCTAssertEqual(returnedElement.selectedLength, 19)
    }
        
    func test_that_if_the_count_is_too_high_it_selects_until_the_lastFileLine_of_the_text_and_still_respects_the_globalColumnNumber() {
        let text = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
  🍅️he wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 123,
            caretLocation: 6,
            selectedLength: 25,
            selectedText: "at one is gonna rip my as",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 123,
                number: 1,
                start: 0,
                end: 41
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 6
        AccessibilityStrategyVisualMode.head = 30
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 78)
    }
    
}


// TextViews
extension ASUT_VMC_return_Tests {
    
    func test_that_if_the_head_is_after_the_anchor_then_it_goes_to_the_line_below_the_head_at_the_first_NonBlank_selects_from_the_anchor_to_that_new_head_location() {
        let text = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
  🍅️he wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 123,
            caretLocation: 41,
            selectedLength: 3,
            selectedText: "and",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 123,
                number: 2,
                start: 41,
                end: 79
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 41
        AccessibilityStrategyVisualMode.head = 43
        
        let returnedElement = applyMoveBeingTested(on: element)
               
        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 43)
    }
    
    func test_that_if_the_head_is_before_the_anchor_and_both_are_on_the_same_line_then_it_goes_to_the_line_below_the_head_at_the_first_nonBlank_and_selects_from_the_anchor_to_that_new_head_location() {
        let text = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
⚒️he wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 120,
            caretLocation: 74,
            selectedLength: 4,
            selectedText: "that",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 120,
                number: 2,
                start: 41,
                end: 79
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 77
        AccessibilityStrategyVisualMode.head = 74
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 77)
        XCTAssertEqual(returnedElement.selectedLength, 4)
    }
    
    func test_that_if_the_head_is_before_the_anchor_and_both_are_not_on_the_same_line_and_the_new_head_location_is_before_the_anchor_then_it_goes_to_the_line_below_the_head_at_the_first_NonBlank_and_selects_from_that_new_head_location_to_the_anchor() {
        let text = """
wow that one is gonna rip my ass off lol
   🥔️nd it's getting even harder now that
the wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 124,
            caretLocation: 33,
            selectedLength: 45,
            selectedText: "off lol\n🥔️nd it's getting even harder now",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 124,
                number: 1,
                start: 0,
                end: 41
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 77
        AccessibilityStrategyVisualMode.head = 33
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 44)
        XCTAssertEqual(returnedElement.selectedLength, 34)
    }
    
    func test_that_it_can_go_back_to_the_last_empty_line_if_the_Visual_Mode_started_from_there_which_means_if_the_anchor_is_there() {
        let text = """
caret is on its
own empty
    line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 26,
            selectedLength: 9,
            selectedText: "    line\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 4,
                start: 26,
                end: 35
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 35
        AccessibilityStrategyVisualMode.head = 26
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 35)
        XCTAssertEqual(returnedElement.selectedLength, 0)
    }
    
    func test_that_it_does_not_go_back_to_the_last_empty_line_if_the_Visual_Mode_did_not_start_from_there_and_instead_selects_till_the_end_of_the_line() {
        let text = """
caret is on its
own empty
    line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 4,
                start: 26,
                end: 35
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 26
        AccessibilityStrategyVisualMode.head = 26
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertNotEqual(returnedElement.caretLocation, 35)
        XCTAssertNotEqual(returnedElement.selectedLength, 0)
    }
    
}
