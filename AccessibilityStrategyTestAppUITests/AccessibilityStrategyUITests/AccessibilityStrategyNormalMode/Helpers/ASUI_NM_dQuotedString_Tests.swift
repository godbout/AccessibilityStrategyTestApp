import XCTest
@testable import AccessibilityStrategy
import Common


// here we test with innerQuotedString, and singleQuote. the other types of quotes
// and aQuotedString are tested in each individual case, with a test that we're passing the proper
// parameters to dQuotedString.
class ASUI_NM_dQuotedString_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.dQuotedString($0.currentFileLine.innerQuotedString, .singleQuote, on: $0, &state) }
    }

}


extension ASUI_NM_dQuotedString_Tests {
    
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
extension ASUI_NM_dQuotedString_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_in_UI_Elements_receptive_to_PGR() {
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

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_and_deletes_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
finally dealing with the 'real stuff'!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
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
