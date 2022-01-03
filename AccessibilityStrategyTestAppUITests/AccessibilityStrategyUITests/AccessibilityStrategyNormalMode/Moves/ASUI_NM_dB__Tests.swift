@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_dB__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        var state = VimEngineState()
        
        return applyMove { asNormalMode.dB(on: $0, pgR: pgR, &state) }
    }
    
}


// both
extension ASUI_NM_dB__Tests {
    
    func test_that_the_block_cursor_ends_up_at_the_right_place() {
        let textInAXFocusedElement = "so we gonna⏰️⏰️trytouse cb here and see 😂️😂️ if it works ⏰️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "u", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "so we use cb here and see 😂️😂️ if it works ⏰️")
        XCTAssertEqual(accessibilityElement?.caretLocation, 6)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(accessibilityElement?.selectedText, "u")
    }
    
}


// PGR
extension ASUI_NM_dB__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "so we gonna⏰️⏰️trytouse cb here and see 😂️😂️ if it works ⏰️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "u", on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "so weuse cb here and see 😂️😂️ if it works ⏰️")
        XCTAssertEqual(accessibilityElement?.caretLocation, 5)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(accessibilityElement?.selectedText, "u")
    }
        
}
