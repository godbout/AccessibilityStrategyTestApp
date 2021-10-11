import XCTest
@testable import AccessibilityStrategy


// internally calling `caw`. here as usual with `d` moves we gonna test
// the caret repositioning.
class UIASNM_daw_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.daw(on: $0) }
    }
    
}


extension UIASNM_daw_Tests {
    
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
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
like honestly that one should be
   📏️traight forward if you ask me
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 36)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_if_the_caret_ends_up_after_the_end_limit_then_it_is_moved_back_to_the_end_limit() {
        let textInAXFocusedElement = """
repositionin🇫🇷️ of
the block cursor is important!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.dollarSign(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
repositionin🇫🇷️
the block cursor is important!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 12)
        XCTAssertEqual(accessibilityElement?.selectedLength, 5)
    }

}
