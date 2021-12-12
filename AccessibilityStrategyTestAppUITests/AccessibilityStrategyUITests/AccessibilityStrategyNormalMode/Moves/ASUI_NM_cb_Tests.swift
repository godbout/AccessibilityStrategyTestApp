@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_cb_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.cb(on: $0, pgR: pgR) }
    }
    
}


// both
extension ASUI_NM_cb_Tests {
    
    func test_that_in_normal_setting_it_selects_the_text_from_the_caret_to_the_character_found() {
        let textInAXFocusedElement = "so we gonna⏰️⏰️trytouse cb here and see 😂️😂️ if it works ⏰️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "u", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "so we gonna⏰️⏰️use cb here and see 😂️😂️ if it works ⏰️")
        XCTAssertEqual(accessibilityElement?.caretLocation, 15)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
   
}


// PGR
extension ASUI_NM_cb_Tests {

    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "so we gonna⏰️⏰️trytouse cb here and see 😂️😂️ if it works ⏰️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "u", on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "so we gonna⏰️use cb here and see 😂️😂️ if it works ⏰️")
        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
   
}
