import XCTest
@testable import AccessibilityStrategy
import Common


// see ci' for blah blah
class ASUI_NM_caDoubleQuote_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested(appFamily: AppFamily) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.caDoubleQuote(on: $0, &state) }
    }

}


// PGR and Electron
extension ASUI_NM_caDoubleQuote_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
finally dealing with the "real stuff"!
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.F(to: "l", on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
finally dealing with the!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 24)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
