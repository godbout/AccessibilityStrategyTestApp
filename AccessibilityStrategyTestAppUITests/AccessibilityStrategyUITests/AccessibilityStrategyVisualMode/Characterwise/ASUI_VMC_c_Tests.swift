import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_VMC_c_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested(appFamily: AppFamily) -> AccessibilityTextElement {
        state.appFamily = appFamily
        
        return applyMove { asVisualMode.c(on: $0, &state) }
    }

}


// PGR and Electron
extension ASUI_VMC_c_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "ok so VM c (hahaha) on a single line"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.f(times: 2, to: "h", on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.f(to: "i", on: $0, state) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "ok so VM c (hangle line")
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
