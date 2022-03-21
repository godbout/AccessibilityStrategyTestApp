import XCTest
import AccessibilityStrategy


// so this is testing the AS escape move. this matches the real Vim
// move, but it will (at least currently) not match the kindaVim move
// because kindaVim will keep the whole selection when pressing escape
// (at least at first) so that we can comment or indent multiple lines easily.
// before, there was no separation of tests between AS and KVE, but now there is
// and responsibility of concerns has to be separate correctly. choices.
class ASUT_VMC_escape_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.escape(on: element)
    }

}


// TextFields
extension ASUT_VMC_escape_Tests {
    
    func test_that_the_caret_location_goes_to_the_head() {
        let text = "some plain simple text for once"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 31,
            caretLocation: 23,
            selectedLength: 8,
            selectedText: "for once",
            visibleCharacterRange: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 1,
                start: 0,
                end: 31
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 30
        AccessibilityStrategyVisualMode.head = 23

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 23)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}


// TextViews
extension ASUT_VMC_escape_Tests {
    
    func test_that_the_caret_location_goes_to_the_head_even_when_the_selection_spans_over_multiple_lines() {
        let text = """
let's try with selecting
🥰️🥰️🥰️ multiple lines
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 49,
            caretLocation: 23,
            selectedLength: 11,
            selectedText: "g\n🥰️🥰️🥰️",
            visibleCharacterRange: 0..<49,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 49,
                number: 3,
                start: 15,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 23
        AccessibilityStrategyVisualMode.head = 31

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 31)
        XCTAssertEqual(returnedElement.selectedLength, 3)
    }
    
    func test_that_if_the_head_is_above_line_end_limit_then_the_caret_goes_to_the_end_limit() {
        let text = """
so this is definitely
gonna go after
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 13,
            selectedLength: 23,
            selectedText: "finitely\ngonna go after",
            visibleCharacterRange: 0..<36,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 2,
                start: 11,
                end: 22
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 13
        AccessibilityStrategyVisualMode.head = 35

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 35)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}
