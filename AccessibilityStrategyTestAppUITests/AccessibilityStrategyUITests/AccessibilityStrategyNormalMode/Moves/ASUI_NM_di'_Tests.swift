import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_diSingleQuote_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.diSingleQuote(on: $0, &state) }
    }

}


extension ASUI_NM_diSingleQuote_Tests {
    
    func test_that_the_block_cursor_is_repositioned_correctly_after_the_deletion() {
        let textInAXFocusedElement = """
finally dealing with the 'real stuff'!
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.F(to: "l", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
finally dealing with the ''!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "'")
        
    }

}


// PGR and Electron
extension ASUI_NM_diSingleQuote_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
finally dealing with the 'real stuff'!
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.F(to: "l", on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
finally dealing with the ''!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "'")
    }

}
