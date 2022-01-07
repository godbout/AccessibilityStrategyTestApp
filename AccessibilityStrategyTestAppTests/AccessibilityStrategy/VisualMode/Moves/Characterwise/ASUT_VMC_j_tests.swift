import XCTest
import AccessibilityStrategy


// for VMC we need to set the CNs else they're nil by default and the move will
// go to the endLimit of the lines. this is not needed for VML as VML takes the whole line.
// we do the tests here in UT coz we don't really need UI as we don't call any AX here, but we
// do have to set CNs and Head and Anchor, so there's a bigger test in UI still, just in case.
class ASUT_VMC_j_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.jForVisualStyleCharacterwise(on: element)
    }

}
    

// TextFields
// Alfred style stuff is handled and tested in kVE now


// TextViews
extension ASUT_VMC_j_Tests {
    
    func test_that_if_the_head_is_after_the_anchor_then_it_goes_to_the_line_below_the_head_on_the_same_column_number_and_selects_from_the_anchor_to_that_new_head_location() {
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
            selectedLength: 3,
            selectedText: "and",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 5,
                start: 41,
                end: 50
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 41
        AccessibilityStrategyVisualMode.head = 43
        
        AccessibilityTextElement.fileLineColumnNumber = 3
        AccessibilityTextElement.screenLineColumnNumber = 3
        
        let returnedElement = applyMoveBeingTested(on: element)
               
        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 41)
    }
    
    func test_that_if_the_head_is_before_the_anchor_and_both_are_on_the_same_line_then_it_goes_to_the_line_below_the_head_on_the_same_column_number_and_selects_from_the_anchor_to_that_new_head_location() {
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
        
        AccessibilityStrategyVisualMode.anchor = 74
        AccessibilityStrategyVisualMode.head = 77
        
        AccessibilityTextElement.fileLineColumnNumber = 34
        AccessibilityTextElement.screenLineColumnNumber = 1
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 74)
        XCTAssertEqual(returnedElement.selectedLength, 39)
    }
    
    func test_that_if_the_head_is_before_the_anchor_and_both_are_not_on_the_same_line_and_the_new_head_location_is_before_the_anchor_then_it_goes_to_the_line_below_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let text = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 119,
            caretLocation: 33,
            selectedLength: 45,
            selectedText: "off lol\nand it's getting even harder now that",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 3,
                start: 26,
                end: 37
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 77
        AccessibilityStrategyVisualMode.head = 33
        
        AccessibilityTextElement.fileLineColumnNumber = 34
        AccessibilityTextElement.screenLineColumnNumber = 8
        
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 74)
        XCTAssertEqual(returnedElement.selectedLength, 4)
    }
        
    func test_that_if_the_line_below_the_head_line_is_shorter_then_it_goes_to_the_end_of_that_line_and_does_not_spill_over_the_next_next_line() {
        let text = """
wow that one is gonna rip my ass off
definitely and maybe
a bit more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 68,
            caretLocation: 13,
            selectedLength: 24,
            selectedText: "is gonna rip my ass off\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 68,
                number: 2,
                start: 13,
                end: 26
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 13
        AccessibilityStrategyVisualMode.head = 36
        
        AccessibilityTextElement.fileLineColumnNumber = 36
        AccessibilityTextElement.screenLineColumnNumber = 10
        
        let returnedElement = applyMoveBeingTested(on: element)
      
        XCTAssertEqual(returnedElement.caretLocation, 13)
        XCTAssertEqual(returnedElement.selectedLength, 45)
    }
    
    func test_that_it_keeps_track_of_the_column_number() {
        let text = """
wow that one is
gonna rip my
ass off lol
extra long one here
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 4,
            selectedLength: 30,
            selectedText: """
that one is
gonna rip my
ass o
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 1,
                start: 0,
                end: 13
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 4
        AccessibilityStrategyVisualMode.head = 33
        
        AccessibilityTextElement.fileLineColumnNumber = 5
        AccessibilityTextElement.screenLineColumnNumber = 5
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 42)
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
        
        AccessibilityTextElement.fileLineColumnNumber = 1
        AccessibilityTextElement.screenLineColumnNumber = 1
        
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
        
        AccessibilityTextElement.fileLineColumnNumber = 1
        AccessibilityTextElement.screenLineColumnNumber = 1

        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertNotEqual(returnedElement.caretLocation, 35)
        XCTAssertNotEqual(returnedElement.selectedLength, 0)
    }
    
}
