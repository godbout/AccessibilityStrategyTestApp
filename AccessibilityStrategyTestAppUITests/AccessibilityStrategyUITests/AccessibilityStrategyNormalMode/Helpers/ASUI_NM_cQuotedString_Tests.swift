@testable import AccessibilityStrategy
import XCTest
import Common


// see UT cQuotedString for more blah blah
class ASUI_NM_cQuotedString_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(using quote: QuoteType, appFamily: AppFamily) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cQuotedString($0.currentFileLine.innerQuotedString, quote, on: $0, &state) }
    }
    
}


// PGR and Electron
extension ASUI_NM_cQuotedString_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
finally dealing with the "real stuff"!
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "l", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: .doubleQuote, appFamily: .pgR)
               
        XCTAssertEqual(accessibilityElement.fileText.value, """
finally dealing with the ""!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
