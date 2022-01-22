@testable import AccessibilityStrategy
import XCTest
import Common


class ASUI_NM_cBb_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cBb(on: $0, using: asNormalMode.b, &state) }
    }
    
}


// PGR and Electron
extension ASUI_NM_cBb_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "so we gonna⏰️⏰️trytouse cb here and see 😂️😂️ if it works ⏰️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "u", on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "so we gonna⏰️use cb here and see 😂️😂️ if it works ⏰️")
        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
   
}
