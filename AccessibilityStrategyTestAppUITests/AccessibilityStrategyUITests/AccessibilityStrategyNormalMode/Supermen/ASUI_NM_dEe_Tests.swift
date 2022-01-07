@testable import AccessibilityStrategy
import XCTest
import VimEngineState


// calling `ce` that is already tested. as usual with `d` moves we test the caret relocation.
// yes, in all those UIT we test only one of the two motions E/e, W/w, etc. that's coz
// 1) it's the same func 2) we're testing that we're passing the right func in UT.
class ASUI_NM_dEe_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement {
        var state = VimEngineState(pgR: pgR)
        
        return applyMove { asNormalMode.dEe(on: $0, using: asNormalMode.e, &state) }
    }
    
}


// both
extension ASUI_NM_dEe_Tests {
    
    func test_that_the_block_cursor_ends_up_at_the_right_place() {
        let textInAXFocusedElement = "😂️😂️😂️😂️ gonna use ce on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "😂️ gonna use ce on this sentence")
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
    func test_that_if_the_caret_ends_up_after_the_end_limit_then_it_is_moved_back_to_the_end_limit() {
        let textInAXFocusedElement = "😂️😂️😂️😂️ gonna use ce on this sentence😂️😂️😂️😂️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "😂️😂️😂️😂️ gonna use ce on this 😂️😂️😂️😂️")
        XCTAssertEqual(accessibilityElement.caretLocation, 34)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "😂️")
    }
   
}


// PGR
extension ASUI_NM_dEe_Tests {

    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "😂️😂️😂️😂️ gonna use ce on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement.fileText.value, " gonna use ce on this sentence")
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
   
}
