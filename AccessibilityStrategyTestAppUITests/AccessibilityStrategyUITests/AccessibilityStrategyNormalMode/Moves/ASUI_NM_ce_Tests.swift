@testable import AccessibilityStrategy
import XCTest


// `ce` uses `e` that uses `FileText.endOfWordForward` that are heavily tested.
// here we just test what's specific to ce.
class ASUI_NM_ce_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.ce(on: $0, pgR: pgR) }
    }
    
}


// both
extension ASUI_NM_ce_Tests {
    
    func test_that_in_normal_setting_it_selects_the_text_from_the_caret_to_the_character_found() {
        let textInAXFocusedElement = "😂️😂️😂️😂️ gonna use ce on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "😂️ gonna use ce on this sentence")
        XCTAssertEqual(accessibilityElement?.caretLocation, 3)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
   
}


// PGR
extension ASUI_NM_ce_Tests {

    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "😂️😂️😂️😂️ gonna use ce on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, " gonna use ce on this sentence")
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
   
}
