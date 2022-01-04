@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_cf_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, pgR: Bool) -> AccessibilityTextElement? {
        var state = VimEngineState(pgR: pgR)
        
        return applyMove { asNormalMode.cf(times: count, to: character, on: $0, &state) }
    }
    
}


// PGR
extension ASUI_NM_cf_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
cf on a multiline
should work
on a line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "w", pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
cf on a multilineork
on a line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 17)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
