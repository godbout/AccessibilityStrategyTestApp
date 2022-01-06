import XCTest
@testable import AccessibilityStrategy


class ASUI_NM_o_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement {
        return applyMove { asNormalMode.o(on: $0, VimEngineState(pgR: pgR)) }
    }
    
}



// PGR
extension ASUI_NM_o_Tests {
    
    func test_that_if_on_the_last_empty_line_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
caret on empty last line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
caret on empty last line



"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 27)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
        
    func test_that_in_other_settings_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
that's a multiline and o will create a new line
between the first file line and the second file line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 1, to: "i", on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
that's a multiline and o will create a new line
iline and o will create a new line

between the first file line and the second file line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 83)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
