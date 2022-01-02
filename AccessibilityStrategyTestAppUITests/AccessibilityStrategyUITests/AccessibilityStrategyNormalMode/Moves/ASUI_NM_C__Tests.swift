@testable import AccessibilityStrategy
import XCTest


// PGR
class ASUI_NM_C__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.C(on: $0, pgR: pgR) }
    }
    
}
    
    
extension ASUI_NM_C__Tests {
        
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
C will now work with file lines and is supposed to delete from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 3, to: "t", on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
                
        XCTAssertEqual(accessibilityElement?.fileText.value, """
C will now work with file lines and is supposed to del
and of course this is in the case there is a linefeed at the end of the line.
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 54)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
