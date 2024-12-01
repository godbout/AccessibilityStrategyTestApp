import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_daSingleQuote_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.daSingleQuote(on: $0, &vimEngineState) }
    }

}


// Both
// TODO: do we need all those tests???
// see da<. seems we should be able to only test the underlying dQuotedString func and
// not all combinations??
extension ASUI_NM_daSingleQuote_Tests {

    func test_that_if_no_innerQuotedString_is_found_then_it_does_nothing() {
        let textInAXFocusedElement = "those shits work on ' single lines not on multiple lines"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.b(times: 10, on: $0) }

        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "those shits work on ' single lines not on multiple lines")
        XCTAssertEqual(accessibilityElement.caretLocation, 6)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "s")
    }

    func test_that_the_block_cursor_is_repositioned_correctly_after_the_deletion() {
        let textInAXFocusedElement = "finally dealing with the 'real stuff'!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.F(to: "l", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "finally dealing with the!")
        XCTAssertEqual(accessibilityElement.caretLocation, 24)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "!")        
    }
    
    func test_that_the_block_cursor_is_repositioned_correctly_even_when_the_quote_is_the_last_character_of_the_line() {
        let textInAXFocusedElement = """
ok so there was 'a bug'
here hehe
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
ok so there was
here hehe
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "s")
    }

}


// PGR and Electron
extension ASUI_NM_daSingleQuote_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
finally dealing with the 'real stuff'!
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
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "!")
    }

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
finally dealing with the 'real stuff'!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.F(to: "l", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
finally dealing with the!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 24)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "!")
    }

}
