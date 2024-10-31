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
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
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
   
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "so we gonna⏰️⏰️trytouse cb here and see 😂️😂️ if it works ⏰️"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "u", on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "so we use cb here and see 😂️😂️ if it works ⏰️")
        XCTAssertEqual(accessibilityElement.caretLocation, 6)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
   
}
