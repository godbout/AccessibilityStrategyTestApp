@testable import AccessibilityStrategy
import XCTest


// see `cw` for blah blah
// but also, this is weird. `cW` works as described in the Vim doc: http://vimdoc.sourceforge.net/htmldoc/motion.html#word
// but `cw` doesn't. currently both work but have different implementation. once we have `innerWORD`, we can replace the
// current implementation of `cW`. even if they would both work, the `innerWORD` one is closer to `cw`, which is the right ome.
class ASUI_NM_cW__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.cW(on: $0, pgR: pgR) }
    }
    
}


// PGR
extension ASUI_NM_cW__Tests {
    
    func test_that_if_the_caret_is_on_a_non_blank_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "😂️😂️😂️😂️hehehe gonna use cw on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, " gonna use cw on this sentence")
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
