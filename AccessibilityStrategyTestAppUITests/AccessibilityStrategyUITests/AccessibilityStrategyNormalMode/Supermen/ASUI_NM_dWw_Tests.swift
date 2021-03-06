@testable import AccessibilityStrategy
import XCTest
import Common


// careful. `dW` is NOT `cW` + caret relocation.
// `cW` may act like `cE` in some cases, but `dW` never acts like `dE`.
// so here compared to the other d moves we need to test count, bipped and LYS as they're not
// tested in a related c move.
class ASUI_NM_dWw_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMoveBeingTested(times: count, &state)
    }
    
    private func applyMoveBeingTested(times count: Int? = 1, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dWw(times: count, on: $0, using: asNormalMode.w, &vimEngineState) }
    }
    
}


// Bip, copy deletion and LYS
extension ASUI_NM_dWw_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_even_for_an_empty_line() {
        let textInAXFocusedElement = "๐๏ธ๐๏ธ๐๏ธ๐๏ธhehehe gonna use ce on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(&state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "๐๏ธ๐๏ธ๐๏ธ")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// count
extension ASUI_NM_dWw_Tests {
    
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = "๐๏ธ๐๏ธ๐๏ธ๐๏ธhehehe gonna use ce on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 3)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "๐๏ธuse ce on this sentence")
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "u")
    }
    
}


// both
extension ASUI_NM_dWw_Tests {
    
    func test_that_the_block_cursor_ends_up_at_the_right_place() {
        let textInAXFocusedElement = "๐๏ธ๐๏ธ๐๏ธ๐๏ธhehehe gonna use ce on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "๐๏ธhehehe gonna use ce on this sentence")
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "h")
    }
    
    func test_that_it_deletes_correctly_when_we_are_at_the_last_word_of_the_text() {
        let textInAXFocusedElement = "๐๏ธ๐๏ธ๐๏ธ๐๏ธhehehe gonna use ce on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "๐๏ธ๐๏ธ๐๏ธ๐๏ธhehehe gonna use ce on this s")
        XCTAssertEqual(accessibilityElement.caretLocation, 40)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "s")
    }
    
}


// TextViews
extension ASUI_NM_dWw_Tests {

}


// PGR and Electron
extension ASUI_NM_dWw_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "๐๏ธ๐๏ธ๐๏ธ๐๏ธhehehe gonna use ce on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "hehehe gonna use ce on this sentence")
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "h")
    }
        
}
