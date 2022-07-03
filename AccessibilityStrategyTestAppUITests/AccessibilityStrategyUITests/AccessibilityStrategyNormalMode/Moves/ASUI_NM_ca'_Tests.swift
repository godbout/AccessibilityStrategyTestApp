import XCTest
@testable import AccessibilityStrategy
import Common

// TODO: do we really need those UI tests here? that PGR is passed properly?

// see ci' for blah blah
class ASUI_NM_caSingleQuote_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested(appFamily: AppFamily) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.caSingleQuote(on: $0, &state) }
    }

}


// PGR and Electron
extension ASUI_NM_caSingleQuote_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
finally dealing with the 'real stuff'!
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.F(to: "l", on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
finally dealing with th!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 23)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
