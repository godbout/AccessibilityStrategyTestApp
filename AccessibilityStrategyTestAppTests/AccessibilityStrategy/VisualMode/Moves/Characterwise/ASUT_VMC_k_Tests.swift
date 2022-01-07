import XCTest
import AccessibilityStrategy
import VimEngineState


// see j for blah blah
class ASUT_VMC_k_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualModeStyle: .characterwise)
                
        return asVisualMode.k(on: element, state)
    }

}
    

// TextFields
// see j for blah blah


// TextViews
extension ASUT_VMC_k_Tests {
    
    func test_that_if_the_head_is_before_the_anchor_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let text = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 119,
            caretLocation: 74,
            selectedLength: 4,
            selectedText: "that",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 8,
                start: 74,
                end: 79
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 77
        AccessibilityStrategyVisualMode.head = 74
        
        AccessibilityTextElement.fileLineColumnNumber = 34
        AccessibilityTextElement.screenLineColumnNumber = 1
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 45)
    }
    
    func test_that_if_the_head_is_after_the_anchor_and_both_are_on_the_same_line_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let text = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 119,
            caretLocation: 79,
            selectedLength: 3,
            selectedText: "the",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 9,
                start: 79,
                end: 91
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 79
        AccessibilityStrategyVisualMode.head = 81
        
        AccessibilityTextElement.fileLineColumnNumber = 3
        AccessibilityTextElement.screenLineColumnNumber = 3

        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 43)
        XCTAssertEqual(returnedElement.selectedLength, 37)
    }
    
    func test_that_if_the_head_is_after_the_anchor_and_both_are_not_on_the_same_line_and_the_new_head_location_is_after_the_anchor_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_the_anchor_to_that_new_head_location() {
        let text = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 119,
            caretLocation: 41,
            selectedLength: 49,
            selectedText: "and it's getting even harder now that\nthe wrapped",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 5,
                start: 41,
                end: 50
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 41
        AccessibilityStrategyVisualMode.head = 89
        
        AccessibilityTextElement.fileLineColumnNumber = 11
        AccessibilityTextElement.screenLineColumnNumber = 11
        
        let returnedElement = applyMoveBeingTested(on: element)
       
        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 11)
    }
    
    func test_that_if_the_head_is_after_the_anchor_and_both_are_not_on_the_same_line_and_the_new_head_location_is_before_the_anchor_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let text = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 119,
            caretLocation: 77,
            selectedLength: 5,
            selectedText: "t\nthe",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 8,
                start: 74,
                end: 79
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 77
        AccessibilityStrategyVisualMode.head = 81
        
        AccessibilityTextElement.fileLineColumnNumber = 3
        AccessibilityTextElement.screenLineColumnNumber = 3
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 43)
        XCTAssertEqual(returnedElement.selectedLength, 35)
    }
    
    // see j for blah blah
    func test_that_it_keeps_track_of_the_column_number() {
        let text = """
extra long one here
ass off lol
gonna rip my
wow that one is
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 31,
            selectedLength: 29,
            selectedText: """
gonna rip my
wow that one is
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 3,
                start: 20,
                end: 32
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 59
        AccessibilityStrategyVisualMode.head = 31
        
        AccessibilityTextElement.fileLineColumnNumber = 12
        AccessibilityTextElement.screenLineColumnNumber = 12

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 11)
        XCTAssertEqual(returnedElement.selectedLength, 49)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_it_works_and_selects_from_the_last_character_to_some_character_of_the_previous_line() {
        let text = """
caret is on its
own empty
    line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 35,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 5,
                start: 35,
                end: 35
            )!
        )
             
        AccessibilityStrategyVisualMode.anchor = 35
        AccessibilityStrategyVisualMode.head = 35
        
        AccessibilityTextElement.fileLineColumnNumber = 1
        AccessibilityTextElement.screenLineColumnNumber = 1
               
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 26)
        // element returns 10 but it will look like 9 as we can't physically
        // select the last empty line character.
        XCTAssertEqual(returnedElement.selectedLength, 10)
    }
    
}
