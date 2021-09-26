import XCTest
import KeyCombination
import AccessibilityStrategy



// internally calling `caw`. here as usual with `d` moves we gonna test
// the caret repositioning.
class UIASNM_daw_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.daw(on: $0) }
    }
    
}


// i guess only one test needed, we set the block cursor to where the caret ended.
// as usual, if last line etc... the Adaptor (or AXEngine) takes care of that.
extension UIASNM_daw_Tests {
    
    func test_that_the_block_cursor_ends_up_at_the_right_place() {
        let textInAXFocusedElement = """
like honestly that one should be
   pretty     📏️traight forward if you ask me
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
like honestly that one should be
   📏️traight forward if you ask me
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 36)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }

}
