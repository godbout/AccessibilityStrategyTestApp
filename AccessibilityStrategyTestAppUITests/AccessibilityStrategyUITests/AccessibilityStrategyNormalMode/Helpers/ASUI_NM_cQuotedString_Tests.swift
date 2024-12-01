@testable import AccessibilityStrategy
import XCTest
import Common


// see UT cQuotedString for more blah blah
class ASUI_NM_cQuotedString_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(using quote: QuoteType, appFamily: AppFamily) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cQuotedString($0.currentFileLine.innerQuotedString, quote, on: $0, &vimEngineState) }
    }
    
}


// PGR and Electron
extension ASUI_NM_cQuotedString_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
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
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
finally dealing with the "real stuff"!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
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
