import XCTest
import KeyCombination
import AccessibilityStrategy


// this calls cF which is already tested in UT. here all we need to test is that
// the block cursor is repositioned correctly when we found the character.
class ASUI_NM_dF__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(with character: Character) -> AccessibilityTextElement? {
        return applyMove(with: character) { character, focusedElement in
            asNormalMode.dF(to: character, on: focusedElement)
        }
    }
    
}


extension ASUI_NM_dF__Tests {
    
    func test_that_the_block_cursor_is_repositioned_correctly_after_the_deletion() {
        let textInAXFocusedElement = """
dF on a multiline
should work
on a lin😂️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "o")
        
        XCTAssertEqual(accessibilityElement?.value, """
dF on a multiline
should work
😂️
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 30)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
   
}
