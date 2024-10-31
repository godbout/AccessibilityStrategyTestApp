import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_ch_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.ch(on: $0, &vimEngineState) }
    }
    
}


// PGR and Electron
extension ASUI_NM_ch_Tests {

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = "ch should delete the correct character"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        var state = VimEngineState(appFamily: .pgR)
        let accessibilityElement = applyMoveBeingTested(&state)

        XCTAssertEqual(accessibilityElement.fileText.value, "ch should delete the correctcharacter")
        XCTAssertEqual(accessibilityElement.caretLocation, 28)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }    
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_and_deletes_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "ch should delete the correct character"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        var state = VimEngineState(appFamily: .pgR)
        let accessibilityElement = applyMoveBeingTested(&state)

        XCTAssertEqual(accessibilityElement.fileText.value, "ch should delete the correctcharacter")
        XCTAssertEqual(accessibilityElement.caretLocation, 28)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }    
    
}
