@testable import AccessibilityStrategy
import XCTest


// as i wrote everywhere, `cw` is weird
// if not on a blank, it acts like `ce`. so we test all that shit here.
class ASUI_NM_cw_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.cw(on: $0, pgR: pgR) }
    }
    
}


// both
extension ASUI_NM_cw_Tests {
    
    func test_that_if_the_caret_is_on_a_non_blank_it_selects_the_text_from_the_caret_to_the_end_of_the_current_word() {
        let textInAXFocusedElement = "😂️😂️😂️😂️hehehe gonna use cw on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "😂️hehehe gonna use cw on this sentence")
        XCTAssertEqual(accessibilityElement?.caretLocation, 3)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_if_the_caret_is_on_a_blank_it_selects_the_text_from_the_caret_to_the_beginning_of_the_next_word() {
        let textInAXFocusedElement = "😂️😂️😂️😂️hehehe                   gonna use cw on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.E(on: $0) }
        applyMove { asNormalMode.l(times: 4, on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "😂️😂️😂️😂️hehehe   gonna use cw on this sentence")
        XCTAssertEqual(accessibilityElement?.caretLocation, 21)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
   
}


// PGR
extension ASUI_NM_cw_Tests {
    
    func test_that_if_the_caret_is_on_a_non_blank_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "😂️😂️😂️😂️hehehe gonna use cw on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "hehehe gonna use cw on this sentence")
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_if_the_caret_is_on_a_blank_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "😂️😂️😂️😂️hehehe                   gonna use cw on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.E(on: $0) }
        applyMove { asNormalMode.l(times: 4, on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "😂️😂️😂️😂️hehehe  gonna use cw on this sentence")
        XCTAssertEqual(accessibilityElement?.caretLocation, 20)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
        
}
