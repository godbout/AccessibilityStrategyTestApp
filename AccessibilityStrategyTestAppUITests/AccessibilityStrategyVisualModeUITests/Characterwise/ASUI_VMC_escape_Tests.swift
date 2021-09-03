import XCTest
import KeyCombination
import AccessibilityStrategy


// TODO: review the failing tests
// currently VM escape has been changed to go back to IM
// and leaving the selection untouched. this is to be able to
// comment or indent multiple lines :D until we build the moves
class ASUI_VMC_escape_Tests: ASUI_VM_BaseTests {}


// TextFields
extension ASUI_VMC_escape_Tests {
    
    func test_that_the_caret_location_goes_to_the_head() {
        let textInAXFocusedElement = "some plain simple text for once"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.escape(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 23)
    }
    
}


// TextViews
extension ASUI_VMC_escape_Tests {
    
    func test_that_the_caret_location_goes_to_the_head_even_when_the_selection_spans_over_multiple_lines() {
        let textInAXFocusedElement = """
let's try with selecting
over multiple lines
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.escape(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 18)
    }
    
    func test_that_if_the_head_is_above_line_end_limit_then_the_caret_goes_to_the_end_limit() {
        let textInAXFocusedElement = """
so this is definitely
gonna go after
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
                
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.escape(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
    }
    
}


// emojis
extension ASUI_VMC_escape_Tests {
    
    func test_that_it_handles_emojis() {
        let textInAXFocusedElement = "wow now that 😂️😂️😂️🙈️"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.escape(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 12)
    }
    
}
