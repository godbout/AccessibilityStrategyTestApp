@testable import AccessibilityStrategy
import XCTest
import Common


class ASUI_NM_cB__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cB(on: $0, &state) }
    }
    
}


// PGR and Electron
extension ASUI_NM_cB__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "so we gonna⏰️⏰️trytouse cb here and see 😂️😂️ if it works ⏰️"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "u", on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "so we use cb here and see 😂️😂️ if it works ⏰️")
        XCTAssertEqual(accessibilityElement.caretLocation, 6)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
   
}
