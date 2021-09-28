import XCTest
import AccessibilityStrategy


// so this is testing the AS escape move. this matches the real Vim
// move, but it will (at least currently) not match the kindaVim move
// because kindaVim will keep the whole selection when pressing escape
// (at least at first) so that we can comment or indent multiple lines easily.
// before, there was no separation of tests between AS and KVE, but now there is
// and responsibility of concerts has to be separate correctly. choices.
class ASUI_VMC_escape_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.escape(on: $0)}
    }

}


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
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 23)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// TextViews
extension ASUI_VMC_escape_Tests {
    
    func test_that_the_caret_location_goes_to_the_head_even_when_the_selection_spans_over_multiple_lines() {
        let textInAXFocusedElement = """
let's try with selecting
🥰️🥰️🥰️ multiple lines
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 31)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
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
        applyMove { asVisualMode.gDollarSignForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.gDollarSignForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 35)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}
