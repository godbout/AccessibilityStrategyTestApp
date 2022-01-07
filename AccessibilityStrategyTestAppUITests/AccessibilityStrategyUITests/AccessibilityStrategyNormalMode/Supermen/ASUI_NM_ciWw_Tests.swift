@testable import AccessibilityStrategy
import XCTest
import VimEngineState


// what we test with those functions like ciWw is that PGR is handled on ciW and ciw.
// it doesn't matter which TE func we pass (innerWORD) in here because all the TE funcs
// are tested independently.
class ASUI_NM_ciWw__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool) -> AccessibilityTextElement {
        var state = VimEngineState(pgR: pgR) 
        
        return applyMove { asNormalMode.ciWw(on: $0, using: $0.fileText.innerWORD, &state) }
    }
    
}


// PGR
extension ASUI_NM_ciWw__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "that's some cute-boobies      text in here don't you think?"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "c", on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "that's some      text in here don't you think?")
        XCTAssertEqual(accessibilityElement.caretLocation, 11)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
