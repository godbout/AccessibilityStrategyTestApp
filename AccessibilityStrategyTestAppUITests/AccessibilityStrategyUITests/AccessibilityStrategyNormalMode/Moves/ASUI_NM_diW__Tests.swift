import XCTest
@testable import AccessibilityStrategy


// see daw for blah blah
class ASUI_NM_diW__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.diW(on: $0, pgR: pgR) }
    }
    
}


extension ASUI_NM_diW__Tests {
    
    func test_that_the_block_cursor_ends_up_at_the_right_place() {
        let textInAXFocusedElement = """
like honestly that one should be
   pretty-much     📏️traight forward if you ask me
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
like honestly that one should be
        📏️traight forward if you ask me
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 36)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_if_the_caret_ends_up_after_the_end_limit_then_it_is_moved_back_to_the_end_limit() {
        let textInAXFocusedElement = """
repositionin🇫🇷️ of-what
the block cursor is important!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
repositionin🇫🇷️ 
the block cursor is important!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 17)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }

}


// PGR
extension ASUI_NM_diW__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
like honestly that one should be
   pretty-much     📏️traight forward if you ask me
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
like honestly that one should be
       📏️traight forward if you ask me
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 35)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}
