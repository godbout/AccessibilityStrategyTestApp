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

    func test_that_in_normal_setting_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "ch should delete the correct character"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        var state = VimEngineState(appFamily: .pgR)
        let accessibilityElement = applyMoveBeingTested(&state)

        XCTAssertEqual(accessibilityElement.fileText.value, "ch should delete the correccharacter")
        XCTAssertEqual(accessibilityElement.caretLocation, 27)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }    
    
}
