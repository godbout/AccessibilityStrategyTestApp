import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_cl_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.cl(on: $0, &vimEngineState) }
    }
    
}


// PGR and Electron
extension ASUI_NM_cl_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "x should delete the right character"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        var state = VimEngineState(appFamily: .pgR)
        let accessibilityElement = applyMoveBeingTested(&state)

        XCTAssertEqual(accessibilityElement.fileText.value, "x should delete the right haracter")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
}
