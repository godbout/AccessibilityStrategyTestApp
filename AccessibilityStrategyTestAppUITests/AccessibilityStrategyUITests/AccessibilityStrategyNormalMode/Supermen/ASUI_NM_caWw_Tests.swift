@testable import AccessibilityStrategy
import XCTest
import VimEngineState


class ASUI_NM_caWw_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: VimEngineAppFamily) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.caWw(on: $0, using: $0.fileText.aWord, &state) }
    }
    
}


// PGR and Electron
extension ASUI_NM_caWw_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "that's some cute      text in here don't you think?"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "c", on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
           
        XCTAssertEqual(accessibilityElement.fileText.value, "that's sometext in here don't you think?")
        XCTAssertEqual(accessibilityElement.caretLocation, 11)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
