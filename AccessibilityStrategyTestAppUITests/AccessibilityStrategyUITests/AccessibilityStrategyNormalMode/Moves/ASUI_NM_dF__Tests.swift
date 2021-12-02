import XCTest
@testable import AccessibilityStrategy


// this calls cF which is already tested in UT. here all we need to test is that
// the block cursor is repositioned correctly when we found the character.
class ASUI_NM_dF__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(with character: Character, pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove(with: character) { character, focusedElement in
            asNormalMode.dF(to: character, on: focusedElement, pgR: pgR)
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
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
dF on a multiline
should work
😂️
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 30)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
   
}


// PGR
extension ASUI_NM_dF__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
dF on a multiline
should work
on a lin😂️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "o", pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
dF on a multiline
should work😂️
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 29)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
}
