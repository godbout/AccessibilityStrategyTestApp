import XCTest
@testable import AccessibilityStrategy
import VimEngineState


// internally calling `caw`. here as usual with `d` moves we gonna test
// the caret repositioning.
class ASUI_NM_daWw_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: VimEngineAppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.daWw(on: $0, using: $0.fileText.aWord, &state) }
    }
    
}


// copy deleted text
extension ASUI_NM_daWw_Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
        let textInAXFocusedElement = """
like honestly that one should be
   pretty     📏️traight forward if you ask me
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        copyToClipboard(text: "some fake shit")
        _ = applyMoveBeingTested()
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "pretty     ")
    }
    
}


extension ASUI_NM_daWw_Tests {
    
    func test_that_the_block_cursor_ends_up_at_the_right_place() {
        let textInAXFocusedElement = """
like honestly that one should be
   pretty     📏️traight forward if you ask me
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
like honestly that one should be
   📏️traight forward if you ask me
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 36)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_if_the_caret_ends_up_after_the_end_limit_then_it_is_moved_back_to_the_end_limit() {
        let textInAXFocusedElement = """
repositionin🇫🇷️ of
the block cursor is important!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
repositionin🇫🇷️
the block cursor is important!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 5)
    }

}


// PGR
extension ASUI_NM_daWw_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
like honestly that one should be
   pretty     📏️traight forward if you ask me
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
like honestly that one should be
  📏️traight forward if you ask me
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 35)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
}
