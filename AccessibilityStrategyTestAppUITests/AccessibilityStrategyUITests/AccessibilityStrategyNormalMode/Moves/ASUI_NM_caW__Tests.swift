@testable import AccessibilityStrategy
import XCTest


// PGR
// see ciw for blah blah
class ASUI_NM_caW__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.caW(on: $0, pgR: pgR) }
    }
    
}
    

extension ASUI_NM_caW__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "that's some cute-boobies      text in here don't you think?"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "c", on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement =  applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "that's sometext in here don't you think?")
        XCTAssertEqual(accessibilityElement?.caretLocation, 11)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
