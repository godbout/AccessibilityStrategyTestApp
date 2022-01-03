@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_cF__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, pgR: Bool) -> AccessibilityTextElement? {
        var state = VimEngineState()
        
        return applyMove { asNormalMode.cF(times: count, to: character, on: $0, pgR: pgR, &state) }
    }
    
}


// PGR
extension ASUI_NM_cF__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
cF on a multiline
should work
on a 📏️📏️ line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "o", pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
cF on a multiline
should worke
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 29)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
