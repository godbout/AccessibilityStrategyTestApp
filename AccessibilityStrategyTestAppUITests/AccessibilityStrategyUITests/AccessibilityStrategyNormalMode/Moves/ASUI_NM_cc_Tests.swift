@testable import AccessibilityStrategy
import XCTest


// PGR
class ASUI_NM_cc_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.cc(on: $0, pgR: pgR) }
    }
    
}


extension ASUI_NM_cc_Tests {

    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
but the indent should
   i delete a line
be kept
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
but the indent should
  
be kept
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 24)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
