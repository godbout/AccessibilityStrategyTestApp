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
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
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
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "x should delete the right character"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        var state = VimEngineState(appFamily: .pgR)
        let accessibilityElement = applyMoveBeingTested(&state)

        XCTAssertEqual(accessibilityElement.fileText.value, "x should delete the right haracter")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
}
