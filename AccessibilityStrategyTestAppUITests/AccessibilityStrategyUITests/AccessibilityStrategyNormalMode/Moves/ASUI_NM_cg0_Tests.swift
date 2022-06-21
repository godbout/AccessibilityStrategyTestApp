@testable import AccessibilityStrategy
import XCTest
import Common


class ASUI_NM_cg0_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .pgR)
        
        return applyMove { asNormalMode.cgZero(on: $0, &state) }
    }
    
}
    
    
// PGR and Electron + passing right LineType parameter to cggZero
extension ASUI_NM_cg0_Tests {
        
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text_and_also_passes_the_right_LineType_parameter_to_the_superman_func() {
        let textInAXFocusedElement = """
C will now work with file lines and is supposed to delete from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 3, to: "t", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
                
        XCTAssertEqual(accessibilityElement.fileText.value, """
C will now work with file lines and iste from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 38)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
