import XCTest
import AccessibilityStrategy
import Common


// TODO: some tests have been skipped
class ASUT_VMC_minus_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(visualStyle: .characterwise)
            
        return applyMoveBeingTested(times: count, on: element, &vimEngineState)
    }
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        vimEngineState.visualStyle = .characterwise
        
        return asVisualMode.minus(times: count, on: element, &vimEngineState)
    }

}
    

// TextFields
// see VML for blah blah


// Bip
extension ASUT_VMC_minus_Tests {
    
    func test_that_if_the_head_is_at_the_first_line_then_it_bips() {
        let text = """
well first line
or TV 🍍️
or a TF same same
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 43,
            caretLocation: 5,
            selectedLength: 31,
            selectedText: """
        first line
        or TV 🍍️
        or a TF sa
        """,
            fullyVisibleArea: 0..<43,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 43,
                number: 1,
                start: 0,
                end: 16
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 35
        AccessibilityStrategyVisualMode.head = 5
                
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
    }

}


// count
extension ASUT_VMC_minus_Tests {
    
    func test_it_implements_the_count_system_for_when_the_newHead_is_after_or_equal_to_the_Anchor() throws {
        throw XCTSkip("move not implemented yet")
        
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
            fullyVisibleArea: 0..<123,
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
        
    func test_that_it_implements_the_count_system_for_when_the_newHead_is_before_the_Anchor() throws {
        throw XCTSkip("move not implemented yet")
        
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
            fullyVisibleArea: 0..<123,
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
        
    func test_that_if_the_count_is_too_high_it_selects_until_the_lastFileLine_of_the_text_and_still_respects_the_globalColumnNumber() throws {
        throw XCTSkip("move not implemented yet")
        
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
            fullyVisibleArea: 0..<123,
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
extension ASUT_VMC_minus_Tests {
    
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
            fullyVisibleArea: 0..<123,
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
            fullyVisibleArea: 0..<120,
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
    
    func test_that_if_the_head_is_before_the_anchor_and_both_are_not_on_the_same_line_and_the_new_head_location_is_before_the_anchor_then_it_goes_to_the_line_below_the_head_at_the_first_NonBlank_and_selects_from_that_new_head_location_to_the_anchor() throws {
        throw XCTSkip("move not implemented yet")
        
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
            fullyVisibleArea: 0..<124,
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
            fullyVisibleArea: 0..<35,
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
            fullyVisibleArea: 0..<35,
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
